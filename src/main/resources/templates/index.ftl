<!DOCTYPE html>
<html lang="en_US">
    <head>
        <title>KNote</title>
        <link rel="stylesheet" href="js/tachyons.min.css">
    </head>
    <body class="ph3 pt0 pb4 mw7 center sans-serif">
        <h1 class="f2 mb0"><span class="gold">K</span>Note</h1>
        <p class="f5 mt1 mb4 lh-copy">A simple note-taking app.</p>

        <form action="/note" method="post" enctype="multipart/form-data">
            <ol class="list p10">
                <li class="mv3">
                    <label for="image" class="f6 b db mb2">Upload an image</label>
                    <input type="file" name="image" class="f6 link dim br1 ba b--black-20 ph3 pv2 mb2 dib black bg-white pointer">
                    <input type="submit" name="upload" value="Upload" class="f6 link dim br1 ba bw1 ph3 pv2 mb2 dib black bg-white pointer m12">
                </li>
                <li class="mv3">
                    <label for="description" class="f6 b db mb2">Write your content here</label>
                    <textarea name="description" id="description" rows="5" class="f4 db border-box hover-black w-100 measure ba b--black-20 pa2 br2 mb2"><#if description??>${description}</#if></textarea>
                    <input type="submit" name="publish" value="Publish" class="f6 link dim br1 ba bw1 ph3 pv2 mb2 dib black bg-white pointer">
                </li>
            </ol>
        </form>

        <ul class="list p10">
            <#if notes??>
                <#list notes as note>
                    <li class="mv3 bb bw2 b--light-yellow bg-washed-yellow ph4 pv2"><p class="measure"></p><p>${note}</p><p></p></li>
                </#list>
                <#else>
                    <p class="lh-copy f6">You don't have any notes yet.</p>
            </#if>
        </ul>
    </body>
</html>
