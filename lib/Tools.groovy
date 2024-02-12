/**
 * Represents the options of tools available for different steps.
 */
class Tools {

    /**
     *  Enum representing tools for trimming/filtering reads.
     */
    enum Trim {
        CUTADAPT,
        FASTP

        /**
         * Check if a given tool name matches a valid trim tool.
         *
         * @param tool The tool to check for.
         * @return true if the tool matches any valid trim tool, otherwise false.
         */
        static boolean isTrimTool(String tool) {
            return values().any {it.name().equalsIgnoreCase(tool)}
        }
    }


    /**
     *  Enum representing tools for genome assembly.
     */
    enum Assemble {
        SPADES

        /**
         * Check if a given tool name matches a valid assemble tool.
         *
         * @param tool The tool to check for.
         * @return true if the tool matches any valid assemble tool, otherwise false.
         */
        static boolean isAssembleTool(String tool) {
            return values().any {it.name().equalsIgnoreCase(tool)}
        }
    }
}
