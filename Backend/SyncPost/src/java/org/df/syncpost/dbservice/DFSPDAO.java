/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.df.syncpost.dbservice;
import java.sql.*;
/**
 *
 * @author dmitryfeld
 */
public class DFSPDAO {
    protected String connectionURL;
    public DFSPDAO(String connectionURL) throws SQLException {
        this.connectionURL = connectionURL;
    }
    public Connection open() throws SQLException {        
        return DriverManager.getConnection(this.connectionURL);
    }
    public void close(Connection connection) throws SQLException {
        connection.close();
    }
}
