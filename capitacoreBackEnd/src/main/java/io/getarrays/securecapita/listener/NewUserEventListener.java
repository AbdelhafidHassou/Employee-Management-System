package io.getarrays.securecapita.listener;

import io.getarrays.securecapita.event.NewUserEvent;
import io.getarrays.securecapita.service.EventService;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Component;

import static io.getarrays.securecapita.utils.RequestUtils.getDevice;
import static io.getarrays.securecapita.utils.RequestUtils.getIpAddress;



@Component
@RequiredArgsConstructor
public class NewUserEventListener {
    private final EventService eventService;
    private final HttpServletRequest request;

    @EventListener
    public void onNewUserEvent(NewUserEvent event) {
        eventService.addUserEvent(event.getEmail(), event.getType(), getDevice(request), getIpAddress(request));
    }
}
