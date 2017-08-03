/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.df.syncpost.processors;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author dmitryfeld
 */
public class DFSPSignonProcessor {
    public static Boolean process(HttpServletRequest request,HttpServletResponse response) {
        Boolean result = false;
        String requestURI = request.getRequestURI();
        if(requestURI.contains("aas/signon")) {
            DFSPSignonProcessor mapper = new DFSPSignonProcessor();
            result = mapper.processRequestWithResponse(request, response);
        }
        return result;
    }
    public Boolean processRequestWithResponse(HttpServletRequest request,HttpServletResponse response) {
        Boolean result = false;
        String requestURI = request.getRequestURI();
        if(requestURI.contains("requestmap")) {
            ServletContext cntx= request.getServletContext();
            String filename = cntx.getRealPath("WEB-INF/requestmaps/requestmap.json");
            String mime = cntx.getMimeType(filename);
            if (null == mime) {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            } else {
                try {
                    File file = new File(filename);
                    response.setContentLength((int)file.length());
                    response.setContentType(mime);

                    FileInputStream in = new FileInputStream(file);
                    OutputStream out = response.getOutputStream();

                    // Copy the contents of the file to the output stream
                    byte[] buf = new byte[1024];
                    int count = 0;
                    while ((count = in.read(buf)) >= 0) {
                        out.write(buf, 0, count);
                    }
                    out.close();
                    in.close();
                    
                    result = true;
                } catch (IOException ex) {
                    
                } finally {
                    
                }
            }
        }
        return result;
    }
}
