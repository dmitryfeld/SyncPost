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
public class DFSPMember extends DFSPModel {
    public DFSPMember(HttpServletRequest request) {
        super(request,new String[]{"memberId","memberName","firstName","lastName","displayName","comment"});
    }
    public DFSPMember(ResultSet resultSet) {
        super(resultSet,new String[]{"memberId","memberName","firstName","lastName","displayName","comment"});
    }
    public String getMemberId() {
        return this.getValue("memberId");
    }
    public String getMemberName() {
        return this.getValue("memberName");
    }
    public String getFirstName() {
        return this.getValue("firstName");
    }
    public String getLastName() {
        return this.getValue("lastName");
    }
    public String getDisplayName() {
        return this.getValue("displayName");
    }
    public String getComment() {
        return this.getValue("comment");
    }
    @Override 
    public void injectPK(String pk) {
        super.setValueForKey(pk,"memberId");
    }
    @Override
    public String getTableName() {
        return "MEMBERS";
    }
}
