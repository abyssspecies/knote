package io.train.abyssspecies.knote.props;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.context.properties.ConfigurationProperties;

/**
 * Description...
 *
 * @author abyss species 2021-06
 */
@ConfigurationProperties(prefix = "knote")
public class KnoteProperties {
    @Value("${uploadDir:/tmp/uploads/}")
    private String uploadDir;

    public String getUploadDir() {
        return uploadDir;
    }
}
