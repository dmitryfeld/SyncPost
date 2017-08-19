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
import org.df.syncpost.model.DFSPSignonRequest;

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
            DFSPSignonProcessor processor = new DFSPSignonProcessor();
            result = processor.processRequestWithResponse(request, response);
        }
        return result;
    }
    public Boolean processRequestWithResponse(HttpServletRequest request,HttpServletResponse response) throws IOException {
        Boolean result = false;
        String requestURI = request.getRequestURI();
        if(requestURI.contains("aas/signon")) {
            DFSPSignonRequest template = new DFSPSignonRequest(request);
            String memberName = template.getMemberName();
            String password = template.getPassword();
            if ((null != memberName) && (3 < memberName.length())) {
                List<DFSPModel> credentials = persister.members("select * from CREDENTIALS where MEMBER_NAME = '" + memberName + "'");
                if (1 == credentials.size()) {
                    DFSPModel model = (DFSPCredentials)credentials.get(0);
                    if (model instanceof DFSPCredentials) {
                        DFSPCredentials cred = (DFSPCredentials)model;
                        if (cred.getPassword().equalsIgnoreCase(password)) {
                            this.revokeAllAuthorizations(cred);
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
            } else {
                this.marshalError(DFSPError.ERRORS.INVALID_MEMBER_NAME, response);
            }
        } else {
            this.marshalError(DFSPError.ERRORS.INVALID_REQUEST, response);
        }
        return result;
    }
    private void revokeAllAuthorizations(DFSPCredentials cred) {
        List<DFSPModel> authorizations = this.persister.members("select * from AUTHORIZATIONS where CREDENTIALS_ID = " + cred.getCredentialsId());
        for (DFSPModel model : authorizations) {
            if (model instanceof DFSPAuthorization) {
                DFSPAuthorization auth = (DFSPAuthorization)model;
                if (true == auth.isCurrent()) {
                    auth.setExpired();
                }
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
            String body = "{\"name\":\"signon\",\"error\":" + error.toJSON() + ",\"content\":{}}";
            out.println(body);
        } finally {
            out.close();
        }
    }

    private boolean hasOpenAuthorization(DFSPCredentials cred) {
        List<DFSPModel> authorizations = this.persister.members("select * from AUTHORIZATIONS where CREDENTIALS_ID = " + cred.getCredentialsId() + " and EXPIRED_TIME = 0");
        return authorizations.size() > 0;
    }
}
