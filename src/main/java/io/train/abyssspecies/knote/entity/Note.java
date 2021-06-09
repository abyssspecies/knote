package io.train.abyssspecies.knote.entity;

import lombok.*;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

/**
 * Description...
 *
 * @author abyss species 2021-06
 */
@Document(collection = "notes")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Note {
    @Id
    private String id;
    private String description;

    @Override
    public String toString() {
        return description;
    }
}
