/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.df.syncpost.model;

import java.sql.ResultSet;
import javax.servlet.http.HttpServletRequest;

/**
 *
 * @author dmitryfeld
 */
public class DFSPAuthorization extends DFSPModel {
    public DFSPAuthorization(HttpServletRequest request) {
        super(request,new String[] {"authorizationId","credentialsId","token","createdTime","removedTime","isCurrent"});
    }
    public DFSPAuthorization(ResultSet resultSet) {
        super(resultSet,new String[] {"authorizationId","credentialsId","token","createdTime","removedTime","isCurrent"});
    }
    public String getAuthorizationId() {
        return super.getValue("authorizationId");
    }
    public String getCredentialsId() {
        return super.getValue("credentialsId");
    }
    public String getToken() {
        return super.getValue("token");
    }
    public String getCreatedTime() {
        return super.getValue("createdTime");
    }
    public String getRemovedTime() {
        return super.getValue("removedTime");
    }
    public String isCurrent() {
        return super.getValue("isCurrent");
    }
}
