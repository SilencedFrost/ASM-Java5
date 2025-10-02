package com.api;

import com.constants.AuthFields;
import com.dto.OutboundUserDTO;
import com.service.UserService;
import com.util.JsonUtil;
import com.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.Map;
import java.util.logging.Logger;

import static com.util.ServletUtil.getAction;

@WebServlet("/api/auth/*")
public class AuthAPI extends HttpServlet {
    private static final Logger logger = Logger.getLogger(AuthAPI.class.getName());
    private static final UserService userService = new UserService();
    private static final String requestUrl = "/auth";

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = getAction(req);
        logger.info("Post request received");

        HttpSession session = req.getSession();

        if(action.length() == requestUrl.length()) {
            JsonUtil.sendJsonResp(resp, Map.of("error", "Malformed url"), HttpServletResponse.SC_BAD_REQUEST);
        } else {
            switch(action.substring(requestUrl.length() + 1)) {
                case "login" -> {
                    Object user = session.getAttribute("user");

                    if (user instanceof OutboundUserDTO outboundUser) {
                        JsonUtil.sendJsonResp(resp, outboundUser, HttpServletResponse.SC_OK);
                    } else {
                        Map<String, String> inputData = JsonUtil.readJsonAsMap(req);
                        String usernameOrEmail = inputData.get(AuthFields.USERNAME_OR_EMAIL.getPropertyKey());
                        String password = inputData.get(AuthFields.PASSWORD.getPropertyKey());

                        if(ValidationUtil.isNullOrBlank(usernameOrEmail) && ValidationUtil.isNullOrBlank(password)) {
                            JsonUtil.sendJsonResp(resp, Map.of("error", "User not in session"), HttpServletResponse.SC_UNAUTHORIZED);
                        } else {
                            OutboundUserDTO userDTO = userService.findByUsernameOrEmail(usernameOrEmail);

                            if(userDTO != null && userService.validateUser(password, userDTO.getUserId())) {
                                userService.updateLoginDate(userDTO.getUserId());
                                userDTO.setLastLoginDate(LocalDateTime.now());
                                JsonUtil.sendJsonResp(resp, userDTO, HttpServletResponse.SC_OK);
                                session.setAttribute("user", userDTO);
                            } else {
                                JsonUtil.sendJsonResp(resp, Map.of("error", "Incorrect credentials"), HttpServletResponse.SC_UNAUTHORIZED);
                            }
                        }
                    }
                }case "logout" -> session.invalidate();
                case "signup" -> {

                }default -> JsonUtil.sendJsonResp(resp, Map.of("error", "Malformed url"), HttpServletResponse.SC_BAD_REQUEST);
            }
        }
    }
}
