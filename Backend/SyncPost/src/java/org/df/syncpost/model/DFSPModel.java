/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.df.syncpost.model;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Iterator;
import javax.servlet.http.HttpServletRequest;

/**
 *
 * @author dmitryfeld
 */
public abstract class DFSPModel {
    private final HashMap<String,String> content;
    public DFSPModel() {
        this.content = new HashMap<String,String>();
    }
    public DFSPModel(DFSPModel model) {
        this.content = new HashMap<String,String>(model.content);
    }
    public DFSPModel(HttpServletRequest request,String[] names) {
        this.content = new HashMap<String,String>();
        for (String name : names) {
            String value = request.getHeader(name);
            if (null != value) {
                this.content.put(name, value);
            }
        }
    }
    public DFSPModel(ResultSet resultSet,String[] names) {
        this.content = new HashMap<String,String>();
        for (String name : names) {
            try {
                String value = resultSet.getObject(name,String.class);
                if (null != value) {
                    this.content.put(name, value);
                }
            } catch (SQLException exception) {
                
            } finally {
                
            }
        }
    }
    public String getValue(String key) {
        return this.content.get(key);
    }
    @Override
    public int hashCode() {
        int hash = 7;
        hash = 71 * hash + (this.content != null ? this.content.hashCode() : 0);
        return hash;
    }
    @Override
    public boolean equals(Object call) {
        if (!(call instanceof DFSPModel)) {
            return false;
        }
        DFSPModel obj = (DFSPModel)call;
        return this.content.equals(obj.content);
    }
    
    public String toJSON() {
        String result = "{";
        Iterator<String> iter = this.content.keySet().iterator();
        String key,value;
        while (iter.hasNext()) {
            key = iter.next();
            value = this.content.get(key);
            if (null != value) {
                result += "\"" + key + "\":" + value;
                if (iter.hasNext()) {
                    result += ",";
                }   
            }
        }
        result = "}";        
        return result;
    }
    public String toSQL() {
        String result = "";
        Iterator<String> iter = this.content.keySet().iterator();
        String key,value;
        while (iter.hasNext()) {
            key = iter.next();
            value = this.content.get(key);
            if (null != value) {
                result += "\"" + key + "\"=" + value;
                if (iter.hasNext()) {
                    result += ",";
                }   
            }
        }       
        return result;
    }
    
    protected final String string(String string) {
        if (null == string) {
            string = "";
        }
        return string;
    }
}
