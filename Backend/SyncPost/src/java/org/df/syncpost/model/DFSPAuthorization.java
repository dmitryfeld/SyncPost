/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.df.syncpost.model;

import java.sql.ResultSet;
import java.util.Date;
import java.util.UUID;
import javax.servlet.http.HttpServletRequest;

/**
 *
 * @author dmitryfeld
 */
public class DFSPAuthorization extends DFSPModel {
    public DFSPAuthorization(String authorizationId, String credentialsId) {
        super();
        Date now = new Date();
        super.setValueForKey(authorizationId, "authorizationId");
        super.setValueForKey(credentialsId, "credentialsId");
        super.setValueForKey(UUID.randomUUID().toString(), "token");
        super.setValueForKey("" + now.getTime(), "createdTime");
        super.setValueForKey("true", "isCurrent");
    }
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
    @Override 
    public void injectPK(String pk) {
        super.setValueForKey(pk,"authorizationId");
    }
    @Override
    public String getTableName() {
        return "AUTHORIZATIONS";
    }
    public void discard() {
        Date now = new Date();
         super.setValueForKey("" + now.getTime(), "removedTime");
        super.setValueForKey("false", "isCurrent");
    }
}
