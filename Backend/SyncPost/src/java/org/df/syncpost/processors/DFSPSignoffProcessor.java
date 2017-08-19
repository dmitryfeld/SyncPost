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
import org.df.syncpost.model.DFSPSignoffRequest;

/**
 *
 * @author dmitryfeld
 */
public class DFSPSignoffProcessor {
    private final DFSPDBSeed seed;
    private final DFSPDBPersister persister;
    public DFSPSignoffProcessor () {
        super();
        this.seed = new DFSPDBSeed();
        this.persister = new DFSPDBPersister("auth");
    }
    public static Boolean process(HttpServletRequest request,HttpServletResponse response) throws IOException {
        Boolean result = false;
        String requestURI = request.getRequestURI();
        if(requestURI.contains("aas/signoff")) {
            DFSPSignoffProcessor processor = new DFSPSignoffProcessor();
            result = processor.processRequestWithResponse(request, response);
        }
        return result;
    }
    public Boolean processRequestWithResponse(HttpServletRequest request,HttpServletResponse response) throws IOException {
        Boolean result = false;
        String requestURI = request.getRequestURI();
        if(requestURI.contains("aas/signoff")) {
            DFSPSignoffRequest template = new DFSPSignoffRequest(request);
            String authorizationId = template.getAuthorizationId();
            String token = template.getToken();
            if ((null != authorizationId) && (0 < authorizationId.length())) {
                List<DFSPModel> authorizations = persister.members("select * from AUTHORIZATIONS where AUTHORIZATION_ID = " + authorizationId + " and EXPIRED_TIME = 0");
                if (1 == authorizations.size()) {
                    DFSPModel model = (DFSPAuthorization)authorizations.get(0);
                    if (model instanceof DFSPAuthorization) {
                        DFSPAuthorization auth = (DFSPAuthorization)model;
                        if (auth.getToken().equalsIgnoreCase(token)) {
                            auth.setExpired();
                            this.persister.saveModel(model);
                            this.marshalAuthorization(auth, response);
                        } else {
                            this.marshalError(DFSPError.ERRORS.INVALID_AUTHORIZATION, response);
                        }
                    } else {
                        this.marshalError(DFSPError.ERRORS.INVALID_REQUEST, response);
                    }
                } else {
                    this.marshalError(DFSPError.ERRORS.AUTHORIZATION_NOT_FOUND, response);
                }
            } else {
                this.marshalError(DFSPError.ERRORS.INVALID_AUTHORIZATION_ID, response);
            }
        } else {
            this.marshalError(DFSPError.ERRORS.INVALID_REQUEST, response);
        }
        return result;
    }
    private void marshalAuthorization(DFSPAuthorization auth,HttpServletResponse response) throws IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {
           String body = "{\"name\":\"signoff\",\"error\":{\"code\":\"0\",\"message\":\"\"},\"content\":";
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
}
