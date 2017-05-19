package com.squarenest;

import org.eclipse.jetty.client.HttpClient;
import org.eclipse.jetty.client.api.ContentResponse;
import org.eclipse.jetty.client.api.Request;
import org.eclipse.jetty.client.util.StringContentProvider;
import org.eclipse.jetty.http2.client.HTTP2Client;
import org.eclipse.jetty.http2.client.http.HttpClientTransportOverHTTP2;
import org.eclipse.jetty.util.ssl.SslContextFactory;

import java.io.FileInputStream;
import java.security.KeyStore;

public class Main {

    private static String token = "2874fb555f27e2475d1d166579b3e1d54b7dcf55045feb2ed41e73edc0dd3938";
    private static String host = "https://api.development.push.apple.com";
    private static String payload = "{\"aps\":{\"alert\":\"Testing.. (0)\",\"badge\":1,\"sound\":\"default\"}}";
    private static String passphrase = "syncpost";

    public static void main(String[] args) throws Exception {

        HTTP2Client http2Client = new HTTP2Client();
        http2Client.start();

        KeyStore ks = KeyStore.getInstance("PKCS12");
        ks.load(new FileInputStream("SyncPostDevCert.p12"), passphrase.toCharArray());

        SslContextFactory ssl = new SslContextFactory(true);
        ssl.setKeyStore(ks);
        ssl.setKeyStorePassword(passphrase);

        HttpClient client = new HttpClient(new HttpClientTransportOverHTTP2(http2Client), ssl);
        client.start();

        Request req = client.POST(host)
                .path("/3/device/" + token)
                .content(new StringContentProvider(payload));

        try {
            ContentResponse response = req.send();
            System.out.println("response code: " + response.getStatus());
            System.out.println("response body: " + response.getContentAsString());
        }
        catch (Exception ex){
            System.out.println("responce is unavailable");
        }

    }
}
