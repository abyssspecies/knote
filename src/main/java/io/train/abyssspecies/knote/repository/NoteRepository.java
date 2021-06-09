package io.train.abyssspecies.knote.repository;

import io.train.abyssspecies.knote.entity.Note;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

/**
 * Description...
 *
 * @author abyss species 2021-06
 */
@Repository
public interface NoteRepository extends MongoRepository<Note, String> {
}
