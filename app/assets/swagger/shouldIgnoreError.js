/**
 * Chose which swagger errors to ignore.
 * @param {Error} err the error being caught.
 * @returns {boolean} whether or not to ignore the error.
 */
const shouldIgnoreError = (err) => {
    const example = err.location.match(/Structural\ error\ (.*)openapi/);
    console.debug(example);
    // This error is because the validator is still based on swagger-editor instead of swagger-editor-next.
    if (/Structural\ error\ .*openapi/.test(err.location)) {
        return true;
    }
    return false;
};

module.exports = shouldIgnoreError;
