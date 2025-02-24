/**
 * Validate required params
 *
 * Check that required params exist. Throw exit status 64 if they don't.
 *
 * @param params The params for the Nextflow pipeline.
 * @param log The Nextflow log object.
 *
 * @return null
 */
static void validateRequiredParams(params, log) {
    validateProjectTitle(params, log)
    validateSamplesheet(params, log)
    validateGenome(params, log)
    validateAnnotations(params, log)
    validateTrimTool(params, log)
    validateAssembleTool(params, log)
}


/**
 * Validate project title
 *
 * Check that projectTitle param exists. Throw exit status 64 if it doesn't.
 *
 * @param params The params for the Nextflow pipeline.
 * @param log The Nextflow log object.
 *
 * @return null
 */
static void validateProjectTitle(params, log) {
    if (params.projectTitle) {
        log.info "Project title: '${params.projectTitle}'"
    } else {
        log.error "Parameter 'projectTitle' is required but was not provided."
        System.exit(64)
    }
}


/**
 * Validate samplehseet
 *
 * Check that samplesheet param exists. Throw exit status 64 if it doesn't.
 *
 * @param params The params for the Nextflow pipeline.
 * @param log The Nextflow log object.
 *
 * @return null
 */
static void validateSamplesheet(params, log) {
    if (params.samplesheet) {
        log.info "Using samplesheet '${params.samplesheet}'"
    } else {
        log.error "Parameter 'samplesheet' is required but was not provided."
        System.exit(64)
    }
}


/**
 * Validate genome
 *
 * Check that genome param exists. Throw exit status 64 if it doesn't.
 *
 * @param params The params for the Nextflow pipeline.
 * @param log The Nextflow log object.
 *
 * @return null
 */
static void validateGenome(params, log) {
    if (params.genome) {
        log.info "Using reference genome '${params.genome}'"
    } else {
        log.error "Parameter 'genome' is required but was not provided."
        System.exit(64)
    }
}


/**
 * Validate annotations
 *
 * Check that annotations param exists. Throw exit status 64 if it doesn't.
 *
 * @param params The params for the Nextflow pipeline.
 * @param log The Nextflow log object.
 *
 * @return null
 */
static void validateAnnotations(params, log) {
    if (params.annotations) {
        log.info "Using reference annotations '${params.annotations}'"
    } else {
        log.error "Parameter 'annotations' is required but was not provided."
        System.exit(64)
    }
}


/**
 * Validate trim tool.
 *
 * Check that trim tool param exists and is a valid trim tool.
 * Throw exit status 64 if otherwise.
 *
 * @param params The params for the Nextflow pipeline.
 * @param log The Nextflow log object.
 *
 * @return null
 */
static void validateTrimTool(params, log) {
    if (params.tools.trim) {
        if (Tools.Trim.isTrimTool(params.tools.trim)) {
            log.info "Using trim tool '${params.tools.trim}'"
        } else {
            log.error "'${params.tools.trim}' is not a valid trim tool."
            System.exit(64)
        }
    } else {
        log.error "Parameter 'tools.trim' is required but was not provided."
        System.exit(64)
    }
}


/**
 * Validate assemble tool.
 *
 * Check that assemble tool param exists and is a valid assemble tool.
 * Throw exit status 64 if otherwise.
 *
 * @param params The params for the Nextflow pipeline.
 * @param log The Nextflow log object.
 *
 * @return null
 */
static void validateAssembleTool(params, log) {
    if (params.tools.assemble) {
        if (Tools.Assemble.isAssembleTool(params.tools.assemble)) {
            log.info "Using assemble tool '${params.tools.assemble}'"
        } else {
            log.error "'${params.tools.assemble}' is not a valid assemble tool."
            System.exit(64)
        }
    } else {
        log.error "Parameter 'tools.assemble' is required but was not provided."
        System.exit(64)
    }
}
