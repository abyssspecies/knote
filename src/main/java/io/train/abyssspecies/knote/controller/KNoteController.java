package io.train.abyssspecies.knote.controller;

import io.train.abyssspecies.knote.entity.Note;
import io.train.abyssspecies.knote.props.KnoteProperties;
import io.train.abyssspecies.knote.repository.NoteRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.commonmark.node.Node;
import org.commonmark.parser.Parser;
import org.commonmark.renderer.html.HtmlRenderer;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.util.Collections;
import java.util.List;
import java.util.Objects;
import java.util.UUID;

/**
 * Description...
 *
 * @author abyss species 2021-06
 */
@Slf4j
@Controller
@RequiredArgsConstructor(onConstructor = @__(@Autowired))
public class KNoteController {
    private final NoteRepository noteRepository;
    private final KnoteProperties knoteProperties;
    private final Parser parser = Parser.builder().build();
    private final HtmlRenderer renderer = HtmlRenderer.builder().build();

    @GetMapping("/")
    public String index(Model model) {
        getAllNotes(model);
        return "index";
    }

    @PostMapping("/note")
    public String saveNotes(@RequestParam("image") MultipartFile file,
                            @RequestParam("description") String description,
                            @RequestParam(value = "publish", required = false) String publish,
                            @RequestParam(value = "upload", required = false) String upload,
                            Model model) throws IOException {
        if (publish != null && publish.equals("Publish")) {
            saveNote(description, model);
            getAllNotes(model);
            return "redirect:/";
        }
        if (upload != null && upload.equals("Upload")) {
            if (file != null && file.getOriginalFilename() != null && !file.getOriginalFilename().isEmpty()) {
                uploadImage(file, description, model);
            }
            getAllNotes(model);
            return "index";
        }

        return "index";
    }

    private void getAllNotes(Model model) {
        final List<Note> notes = noteRepository.findAll();
        Collections.reverse(notes);
        model.addAttribute("notes", notes);
    }

    private void saveNote(String description, Model model) {
        if (description != null && !description.trim().isEmpty()) {
            final Node document = parser.parse(description.trim());
            final String html = renderer.render(document);
            noteRepository.save(new Note(null, html));
            model.addAttribute("description", null);
        }
    }

    private void uploadImage(MultipartFile file, String description, Model model) throws IOException {
        final File uploadDir = new File(System.getProperty("java.io.tmpdir") + knoteProperties.getUploadDir());
        if (!uploadDir.exists()) {
            final boolean s = uploadDir.mkdirs();
            if (log.isDebugEnabled()) {
                log.debug("mkdir {}, return value: {}", uploadDir, s);
            }
        }
        final String fileId = UUID.randomUUID() + "." + Objects.requireNonNull(file.getOriginalFilename()).split("\\.")[1];
        file.transferTo(new File(uploadDir, fileId));
        model.addAttribute("description", description + " ![](/uploads/" + fileId + ")");
    }
}
