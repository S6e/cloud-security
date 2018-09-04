package de.qaware.oss.cloud.service.dashboard;

import org.eclipse.microprofile.opentracing.Traced;

import javax.enterprise.context.ApplicationScoped;
import javax.inject.Inject;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import java.util.logging.Level;
import java.util.logging.Logger;

@ApplicationScoped
@Path("gui")
public class GuiResource {

    @Inject
    private Logger logger;

    @Inject
    private ProcessServiceClient processService;

    @POST
    @Consumes(MediaType.APPLICATION_FORM_URLENCODED)
    @Traced(operationName = "POST send")
    public Response send(@FormParam("processId") @NotBlank String processId,
                         @FormParam("name") @NotBlank String name,
                         @FormParam("amount") @NotNull Long amount,
                         @HeaderParam("Authorization") @NotBlank String bearer) {
        logger.log(Level.INFO, "Received form POST request ({0}, {1}, {2}, {3}).", new Object[]{processId, name, amount, bearer});
        processService.send(processId, name, amount, bearer);
        return Response.noContent().build();
    }


}
