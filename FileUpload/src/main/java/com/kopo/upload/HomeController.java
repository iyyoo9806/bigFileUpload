package com.kopo.upload;


import java.io.IOException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import lombok.RequiredArgsConstructor;

/**
 * Handles requests for the application home page.
 */
@Controller
@RequiredArgsConstructor
public class HomeController {
	
    private final UploadService uploadService;
    
    @Autowired
    public HomeController(UploadService uploadService) {
        this.uploadService = uploadService;
    }
    
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home() {
		
		return "home";
	}
	
    @RequestMapping(value = "/done", method = RequestMethod.POST)
    public ResponseEntity<String> chunkUpload(@RequestParam("chunk") MultipartFile file,
                                              @RequestParam("chunkNumber") int chunkNumber,
                                              @RequestParam("totalChunks") int totalChunks) throws IOException {
        boolean isDone = uploadService.chunkUpload(file, chunkNumber, totalChunks);

        if (isDone) {
            return new ResponseEntity<String>("File uploaded successfully", HttpStatus.OK);
        } else {
            return new ResponseEntity<String>(HttpStatus.PARTIAL_CONTENT);
        }
    }
}
