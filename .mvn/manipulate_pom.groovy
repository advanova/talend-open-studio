package org.goots.groovy

import org.commonjava.maven.ext.common.ManipulationException
import org.commonjava.maven.ext.core.groovy.BaseScript
import org.commonjava.maven.ext.core.groovy.InvocationPoint
import org.commonjava.maven.ext.core.groovy.InvocationStage
import org.commonjava.maven.ext.core.groovy.PMEBaseScript

@InvocationPoint(invocationPoint = InvocationStage.FIRST)
@PMEBaseScript BaseScript pme

if (!pme.getInvocationStage()) throw new ManipulationException("Run this script via PME")

def root = pme.getProject()

for (p in pme.getProjects()) {

    // Fix the relative path of org.talend.studio:parent-pom
    if (p != root && p.getProjectParent() != null && p.getProjectParent().getGroupId() == "org.talend.studio" && p.getProjectParent().getArtifactId() == "parent-pom") {
        def parent = new org.apache.maven.model.Parent()
        parent.setGroupId(p.getProjectParent().getGroupId())
        parent.setArtifactId(p.getProjectParent().getArtifactId())
        parent.setVersion(p.getProjectParent().getVersion())
        parent.setRelativePath(p.getPom().getAbsoluteFile().getParentFile().toPath().normalize().relativize(new File(root.getPom().getAbsoluteFile().getParentFile(), "studio-se-master/talend.studio.parent.pom/pom.xml").toPath().normalize()).toString())
        p.getModel().setParent(parent)
        println("Setting relativePath of parent for ${p} to ${parent.relativePath}")
    }
}
