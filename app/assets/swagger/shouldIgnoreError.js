/**
 * Chose which swagger errors to ignore.
 * @param {Error} err the error being caught.
 * @returns {boolean} whether or not to ignore the error.
 */
const shouldIgnoreError = (err) => {
    // This error is because the validator is still based on swagger-editor instead of swagger-editor-next.
    console.debug(err);
    console.debug({ ...err });
    console.debug(err.location);
    console.debug(typeof err.location);
    if (/Structural\ error.*openapi/.test(err.location)) {
        return true;
    }
    return false;
};

module.exports = shouldIgnoreError;
