/**
 * Chose which swagger errors to ignore.
 * @param {Error} err the error being caught.
 * @returns {boolean} whether or not to ignore the error.
 */
const shouldIgnoreError = (err) => {
    // This error is because the validator is still based on swagger-editor instead of swagger-editor next.
    if (
        err.location == 'Structural error at openapi' &&
        err.message ==
            'should match pattern "^3\\.0\\.\\d(-.+)?$"\npattern: ^3\\.0\\.\\d(-.+)?$'
    ) {
        return true;
    }
    // This should always be the default fallback return statement.
    return false;
};

module.exports = shouldIgnoreError;
