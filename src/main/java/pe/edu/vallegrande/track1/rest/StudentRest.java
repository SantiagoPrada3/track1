package pe.edu.vallegrande.track1.rest;

import lombok.Data;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@Data
@RestController
public class StudentRest {

    @GetMapping("v1/api/students")
    public Map<String, String> obtenerStudent() {
        return Map.of(
                "dni", "75252365",
                "firstName", "Santiago",
                "lastname", "Prada",
                "date", LocalDateTime.now().toString()
        );
    }
}