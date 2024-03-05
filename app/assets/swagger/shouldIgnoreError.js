/**
 * Chose which swagger errors to ignore.
 * @param {Error} err the error being caught.
 * @returns {boolean} whether or not to ignore the error.
 */
const shouldIgnoreError = (err) => {
    console.debug({...err});
    if (err.lineNo === 2) {
        return true;
    }
    return false;
}

module.exports = shouldIgnoreError
