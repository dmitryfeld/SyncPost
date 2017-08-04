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
public class DFSPError extends DFSPModel {
    public DFSPError(HttpServletRequest request) {
        super(request, new String[]{"code","message"});
    }
    public DFSPError(ResultSet resultSet) {
        super(resultSet, new String[]{"code","message"});
    }
    public String getCode() {
        return this.getValue("code");
    }
    public String getMessage() {
        return this.getValue("message");
    }
    @Override 
    public void injectPK(String pk) {
    }
    @Override
    public String getTableName() {
        return "";
    }
}
