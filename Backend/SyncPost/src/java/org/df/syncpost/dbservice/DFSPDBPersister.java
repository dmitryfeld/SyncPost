/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.df.syncpost.dbservice;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Collections;
import java.util.LinkedList;
import java.util.List;
import java.util.StringTokenizer;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.df.syncpost.model.DFSPAuthorization;
import org.df.syncpost.model.DFSPCredentials;
import org.df.syncpost.model.DFSPMember;
import org.df.syncpost.model.DFSPModel;

/**
 *
 * @author dmitryfeld
 */
public class DFSPDBPersister {
    protected DFSPDAO dao;
    public DFSPDBPersister(String scheme) {
        if (null != scheme) {
            if (scheme.length() >= 2) {
                String fullScheme = "jdbc:derby://localhost:1527/" + scheme;
                try {
                    this.dao = new DFSPDAO(fullScheme);        
                } catch (SQLException ex) {
                    Logger.getLogger(DFSPDBSeed.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        }
        
    }
    public List<DFSPModel> members(String query) {
        List<DFSPModel> result = Collections.synchronizedList(new LinkedList<DFSPModel>());
        try {
            Connection connection = this.dao.open();
            connection.setTransactionIsolation(Connection.TRANSACTION_READ_COMMITTED);
            Statement select = connection.createStatement();
            ResultSet members = select.executeQuery(query);
            DFSPModel model;
            while (members.next()) {
                if (null != (model = this.createModel(query, members))) {
                    result.add(model);
                }
            }
            this.dao.close(connection);
        } catch (SQLException ex) {
            Logger.getLogger(DFSPDBSeed.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            
        }
        return result;
    }
    
    public void saveModel(DFSPModel model) {
        try {
            Connection connection = this.dao.open();
            connection.setTransactionIsolation(Connection.TRANSACTION_READ_COMMITTED);
            PreparedStatement update = null;
            update = connection.prepareStatement("update " + model.getTableName() + " set " + model.toSQL_UPDATE());
            update.execute();
            connection.commit();
            this.dao.close(connection);
        } catch (SQLException ex) {
            Logger.getLogger(DFSPDBSeed.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            
        }
    }
    public void addModel(DFSPModel model) {
        try {
            Connection connection = this.dao.open();
            connection.setTransactionIsolation(Connection.TRANSACTION_READ_COMMITTED);
            PreparedStatement update = null;
            update = connection.prepareStatement("insert into "+ model.getTableName() + " " + model.toSQL_INSERT());
            update.execute();
            connection.commit();
            this.dao.close(connection);
        } catch (SQLException ex) {
            Logger.getLogger(DFSPDBSeed.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            
        }
    }
    
    public DFSPModel createModel(String query,ResultSet results) {
        DFSPModel result = null;
        String tableName = this.tableName(query);
        if (null != tableName) {
            if (tableName.equalsIgnoreCase("AUTHORIZATIONS")) {
                result = new DFSPAuthorization(results);
            } else if (tableName.equalsIgnoreCase("MEMBERS")) {
                result = new DFSPMember(results);
            } else if (tableName.equalsIgnoreCase("CREDENTIALS")) {
                result = new DFSPCredentials(results);
            }
        }
        
        return result;
    }
    
    public String tableName(String selectStatement) {
        String result = null;
        StringTokenizer tokenizer = new StringTokenizer(selectStatement);
        String token;
        int tokenIndex = 0;
        Boolean found = false;
        while (tokenizer.hasMoreTokens()) {
            token = tokenizer.nextToken();
            if (0 == tokenIndex) {
                if (!token.equalsIgnoreCase("select")) {
                    break;
                }
            } else if (token.equalsIgnoreCase("from")) {
                found = true;
            } else if (true == found) {
                result = token;
                break;
            }
            tokenIndex ++;
        }
        return result;
    }
}
