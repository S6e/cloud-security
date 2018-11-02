package de.qaware.oss.cloud.service.dashboard;

import io.opentracing.contrib.cdi.Traced;
import io.opentracing.contrib.jaxrs2.client.ClientTracingFeature;
import org.apache.http.util.EntityUtils;
import org.eclipse.microprofile.faulttolerance.Timeout;

import javax.annotation.PostConstruct;
import javax.annotation.PreDestroy;
import javax.enterprise.context.ApplicationScoped;
import javax.json.Json;
import javax.json.JsonObject;
import javax.ws.rs.BadRequestException;
import javax.ws.rs.client.Client;
import javax.ws.rs.client.ClientBuilder;
import javax.ws.rs.client.Entity;
import javax.ws.rs.client.WebTarget;
import javax.ws.rs.core.Response;
import java.time.temporal.ChronoUnit;
import java.util.concurrent.TimeUnit;

@ApplicationScoped
public class ProcessServiceClient {

    private Client client;
    private Client authClient;
    private WebTarget processService;

    @PostConstruct
    void initialize() {
        client = ClientBuilder.newBuilder()
                .register(ClientTracingFeature.class)
                .connectTimeout(5, TimeUnit.SECONDS)
                .readTimeout(5, TimeUnit.SECONDS)
                .build();

        /*authClient = ClientBuilder.newBuilder()
                .register(ClientTracingFeature.class)
                .connectTimeout(5, TimeUnit.SECONDS)
                .readTimeout(5, TimeUnit.SECONDS)
                .build();*/

        processService = client.target("http://gravitee-gateway.local:8080").path("/process-service/api/process");
    }

    @PreDestroy
    void destroy() {
        client.close();
    }

    @Timeout(value = 5, unit = ChronoUnit.SECONDS)
    @Traced
    public void send(String processId, String name, Long amount, String bearer) {

        /*WebTarget userInfo = authClient.target("keycloak-http.security:80").path("/auth/realms/showcase/protocol/openid-connect/userinfo");
        Response userInfoResponse = userInfo.request().header("Authorization", bearer).get();
*/
        JsonObject payload = Json.createObjectBuilder()
                .add("processId", processId)
                .add("name", name)
                .add("amount", amount)
//                .add("user", userInfoResponse.getEntity().toString())
                .build();

        Response response = processService.request().header("Authorization", bearer).post(Entity.json(payload));
        Response.StatusType statusInfo = response.getStatusInfo();
        if (!Response.Status.Family.SUCCESSFUL.equals(statusInfo.getFamily())) {
            throw new BadRequestException(statusInfo.getReasonPhrase());
        }
    }
}
