/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.df.syncpost.dbservice;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author dmitryfeld
 */
public class DFSPDAO {
    protected String connectionURL;
    public DFSPDAO(String connectionURL) throws SQLException {
        this.connectionURL = connectionURL;
        
        try {
            String driver = "org.apache.derby.jdbc.ClientDriver";
            Class.forName(driver);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(DFSPDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    public Connection open() throws SQLException {        
        return DriverManager.getConnection(this.connectionURL);
    }
    public void close(Connection connection) throws SQLException {
        connection.close();
    }
}
