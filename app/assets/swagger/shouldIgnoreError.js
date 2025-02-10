/**
 * Chose which swagger errors to ignore.
 * @param {Error} err the error being caught.
 * @returns {boolean} whether or not to ignore the error.
 */
const shouldIgnoreError = (err) => {
    // This error is because the validator is still based on swagger-editor instead of swagger-editor-next.
    /**
     * The space after the word 'error' is not a real space, but it is converted to one when being logged
     * out (super fun to diagnose).  It is, however, considered a whitespace character of some sort,
     * so it can be caught by '\s'.  Don't ask how long it took to diagnose this.
     */
    if (/Structural\ error\sat openapi/.test(err.location)) {
        return true;
    }
    return false;
};

module.exports = shouldIgnoreError;
