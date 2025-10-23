package com.example.logindemo.security;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.io.TempDir;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.HttpHeaders;
import org.springframework.mock.web.MockHttpServletResponse;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.web.servlet.MockMvc;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import static org.assertj.core.api.Assertions.assertThat;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@AutoConfigureMockMvc
class HeaderIntegrationTest {

    @Autowired
    private MockMvc mockMvc;

    @TempDir
    Path tempDir;

    @BeforeEach
    void setupUploads() throws IOException {
        // Ensure uploads directory exists and has a sample file
        Path uploadsDir = Paths.get("uploads");
        if (!Files.exists(uploadsDir)) {
            Files.createDirectories(uploadsDir);
        }
        Path sample = uploadsDir.resolve("test.txt");
        Files.write(sample, "hello".getBytes());
    }

    @Test
    void loginPage_hasSecurityHeaders() throws Exception {
        MockHttpServletResponse resp = mockMvc.perform(get("/login"))
                .andExpect(status().isOk())
                .andReturn()
                .getResponse();

        assertThat(resp.getHeader("X-Frame-Options")).isEqualTo("DENY");
        // X-XSS-Protection header format varies by container; ensure present
        assertThat(resp.getHeader("X-XSS-Protection")).isNotNull();
        // Permissions-Policy set by custom filter
        assertThat(resp.getHeader("Permissions-Policy")).contains("geolocation=()");
    }

    @Test
    @WithMockUser(roles = {"RECEPTIONIST"})
    void appointmentsManagement_hasSecurityHeaders() throws Exception {
        MockHttpServletResponse resp = mockMvc.perform(get("/appointments/management"))
                .andExpect(status().isOk())
                .andReturn()
                .getResponse();

        assertThat(resp.getHeader("X-Frame-Options")).isEqualTo("DENY");
        assertThat(resp.getHeader("X-XSS-Protection")).isNotNull();
        assertThat(resp.getHeader("Permissions-Policy")).contains("geolocation=()");
    }

    @Test
    void uploads_areCachedAndSupportETag() throws Exception {
        MockHttpServletResponse resp = mockMvc.perform(get("/uploads/test.txt"))
                .andExpect(status().isOk())
                .andReturn()
                .getResponse();

        String cacheControl = resp.getHeader("Cache-Control");
        assertThat(cacheControl).isNotNull();
        assertThat(cacheControl).contains("max-age=604800"); // 7 days in seconds

        String etag = resp.getHeader(HttpHeaders.ETAG);
        assertThat(etag).isNotNull();

        // Conditional GET should return 304 when ETag matches
        mockMvc.perform(get("/uploads/test.txt").header(HttpHeaders.IF_NONE_MATCH, etag))
                .andExpect(status().isNotModified());
    }
}