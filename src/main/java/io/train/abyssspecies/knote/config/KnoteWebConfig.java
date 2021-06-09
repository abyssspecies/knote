package io.train.abyssspecies.knote.config;

import io.train.abyssspecies.knote.props.KnoteProperties;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.resource.PathResourceResolver;

/**
 * Description...
 *
 * @author abyss species 2021-06
 */
@Configuration
@EnableConfigurationProperties({KnoteProperties.class})
public class KnoteWebConfig implements WebMvcConfigurer {
    @Autowired
    private KnoteProperties knoteProperties;

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/uploads/**")
            .addResourceLocations("file:" + System.getProperty("java.io.tmpdir") + knoteProperties.getUploadDir())
            .setCachePeriod(3600)
            .resourceChain(true)
            .addResolver(new PathResourceResolver());
    }
}
