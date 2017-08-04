/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.df.syncpost.processors;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.df.syncpost.dbservice.DFSPDBPersister;
import org.df.syncpost.dbservice.DFSPDBSeed;
import org.df.syncpost.model.DFSPAuthorization;
import org.df.syncpost.model.DFSPCredentials;
import org.df.syncpost.model.DFSPModel;

/**
 *
 * @author dmitryfeld
 */
public class DFSPSignonProcessor {
    private final DFSPDBSeed seed;
    private final DFSPDBPersister persister;
    public DFSPSignonProcessor () {
        super();
        this.seed = new DFSPDBSeed();
        this.persister = new DFSPDBPersister("auth");
    }
    public static Boolean process(HttpServletRequest request,HttpServletResponse response) throws IOException {
        Boolean result = false;
        String requestURI = request.getRequestURI();
        if(requestURI.contains("aas/signon")) {
            DFSPSignonProcessor mapper = new DFSPSignonProcessor();
            result = mapper.processRequestWithResponse(request, response);
        }
        return result;
    }
    public Boolean processRequestWithResponse(HttpServletRequest request,HttpServletResponse response) throws IOException {
        Boolean result = false;
        String requestURI = request.getRequestURI();
        if(requestURI.contains("aas/signon")) {
            
            DFSPCredentials template = new DFSPCredentials(request);
            List<DFSPModel> credentials = persister.members("select * from CREDENTIALS where MEMBER_NAME is " + template.getMemberName());
            if (1 == credentials.size()) {
                DFSPModel model = (DFSPCredentials)credentials.get(0);
                if (model.getClass().isInstance(DFSPCredentials.class)) {
                    DFSPCredentials cred = (DFSPCredentials)model;
                    if (cred.getPassword().equalsIgnoreCase(template.getPassword())) {
                        this.closeAllAuthorizations(cred);
                        {
                            DFSPAuthorization auth = this.createAuthorization(cred);
                            this.persister.addModel(auth);
                            this.marshalAuthorization(auth, response);
                        }
                    } else {
                        this.marshalError(DFSPError.ERRORS.INVALID_CREDENTIALS, response);
                    }
                } else {
                    this.marshalError(DFSPError.ERRORS.INVALID_REQUEST, response);
                }
            } else {
                this.marshalError(DFSPError.ERRORS.MEMBER_NOT_FOUND, response);
            }
        }
        return result;
    }
    private void closeAllAuthorizations(DFSPCredentials cred) {
        List<DFSPModel> authorizations = this.persister.members("select * from AUTHORIZATIONS where CREDENTIAL_ID = " + cred.getCredentialsId() + "and IS_CURRENT = true");
        for (DFSPModel model : authorizations) {
            if (model.getClass().isInstance(DFSPAuthorization.class)) {
                DFSPAuthorization auth = (DFSPAuthorization)model;
                auth.discard();
            }
        }
        for (DFSPModel model : authorizations) {
            this.persister.saveModel(model);
        }
    } 
    private DFSPAuthorization createAuthorization(DFSPCredentials cred) {
        String nextSeed = "" + this.seed.nextSeed();
        return new DFSPAuthorization(nextSeed,cred.getCredentialsId());
    }
    private void marshalAuthorization(DFSPAuthorization auth,HttpServletResponse response) throws IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {
            //{"name":"signon","error":{"code":"0","message":""},"content":{"userID":"AUROBINDO","authorizationToken":"--TOKEN_TEST__","ttl":"3600"}}
           String body = "{\"name\":\"signon\",\"error\":{\"code\":\"0\",\"message\":\"\"},\"content\":";
           body += auth.toJSON();
           body += "}";

           out.println(body);

        } finally {
            out.close();
        }
    }
    private void marshalError(DFSPError.ERRORS error,HttpServletResponse response) throws IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {
            //{"name":"signon","error":{"code":"111","message":"abiabi"},"content":{}}
            String body = "{\"name\":\"signon\",\"error\":" + error.toJSON() + "\"content\":{}}";
            out.println(body);
        } finally {
            out.close();
        }
    }
}
