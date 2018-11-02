package de.qaware.oss.cloud.service.process.boundary;

import de.qaware.oss.cloud.service.process.integration.ProcessServiceConfig;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.apache.deltaspike.core.api.projectstage.ProjectStage;
import org.eclipse.microprofile.metrics.annotation.Timed;
import org.eclipse.microprofile.opentracing.Traced;

import javax.enterprise.context.ApplicationScoped;
import javax.inject.Inject;
import javax.json.Json;
import javax.json.JsonObject;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

@ApplicationScoped
@Path("config")
@Produces(MediaType.APPLICATION_JSON)
@Api(value = "Process config resource")
public class ConfigResource {

    @Inject
    private ProjectStage projectStage;

    @Inject
    private ProcessServiceConfig config;

    @GET
    @Timed(unit = "milliseconds")
    @Traced(operationName = "GET /api/config")
    @ApiOperation(value = "Get config of process")
    public Response config() {
        JsonObject result = Json.createObjectBuilder()
                .add("projectStage", projectStage.toString())
                .add("serviceName", config.serviceName())
                .add("processingSeconds", config.processingSeconds())
                .build();
        return Response.ok(result).build();
    }

}
