/**
 * Chose which swagger errors to ignore.
 * @param {Error} err the error being caught.
 * @returns {boolean} whether or not to ignore the error.
 */
const shouldIgnoreError = (err) => {
    // This error is because the validator is still based on swagger-editor instead of swagger-editor-next.
    console.debug({ ...err });
    switch (err.location) {
        case 'Structural error at openapi':
            // This gets triggered from the runner using swagger-editor instead of swagger-editor-next
            return true;
        default:
            return false;
    }
};

module.exports = shouldIgnoreError;
