process.env.NODE_ENV = process.env.NODE_ENV || 'development'
check_yarn_integrity: false
const environment = require('./environment')

module.exports = environment.toWebpackConfig()
