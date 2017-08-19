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
public class DFSPSignoffRequest extends DFSPModel {
    public DFSPSignoffRequest(HttpServletRequest request) {
        super(request,new String[] {"authorizationId","token"});
    }
    public DFSPSignoffRequest(ResultSet resultSet) {
        super(resultSet,new String[] {"authorizationId","token"});
    }
    public String getAuthorizationId() {
        return super.getValue("authorizationId");
    }
    public String getToken() {
        return super.getValue("token");
    }
    @Override 
    public void injectPK(String pk) {
        super.setValueForKey(pk,"");
    }
    @Override
    public String getTableName() {
        return "";
    }
    @Override 
    public String getPrimaryKeyName() {
        return "";
    }
}
