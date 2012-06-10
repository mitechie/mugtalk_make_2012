/**
 * Container for interacting with the readable.bmark.us web service.
 *
 * @namespace bookie
 * @module readable
 *
 */
YUI.add('bookie-readable', function (Y) {

    var ns = Y.namespace('bookie.readable');

    var _ = Y.substitute;

    /**
     * Api helper for making calls out to the readable webservice.
     * requests.
     *
     * @class Readable.Api
     * @extends Y.Base
     *
     */
    ns.Api = Y.Base.create('bookie-readable-api', Y.Base, [], {
        /**
         * General constructor
         * @method initializer
         * @constructor
         *
         */
        initializer : function (cfg) {

        },

        /**
         * Generate a full api url to call
         *
         * If user_username is true then perform a replace on the given url
         * with the api instance's username parameter
         *
         * @method build_url
         *
         */
        build_url: function () {
            // make sure the username is in the config as well
            var url = this.get('url');
            return this.get('api_host') + escape(url);
        },

        /**
         * Actually make the ajax call with the given cfg we've setup for use.
         *
         * The callbacks passed are then sent through to be called upon the
         * ajax return.
         *
         * @method call
         * @param {Object} callbacks an object of success/error/complete callbacks
         *     we'll hand json decoded data of the response.
         *
         */
        call: function (callbacks) {
            var that = this,
                cfg = {
                    method: 'GET',
                    headers: {
                        "Content-Type": "application/json",
                        "Accept": "application/json"
                    },
                    sync: that.get('sync'),
                    timeout: 3000,
                    xdr: {use: 'native' }
                },
                args = {
                    callbacks: callbacks
                };

            Y.bookie.request_handler(
                this.build_url(),
                cfg,
                args
            );
        }
    }, {
        ATTRS: {
            /**
             * @attribute api_key
             * @default ""
             * @type String
             *
             */
            api_host: {
                value: "http://readable.bmark.us/readable/"
            },

            /**
             * To force the io requests to be synchronous.
             * @attribute sync
             * @default false
             * @type Bool
             *
             */
            sync: {
                value: false
            },

            /**
             * The url we want to fetch the content from and readable parse.
             *
             * @attribute url
             * @default undefined
             * @type String
             * @required
             *
             */
            url: {}
        }
    });
}, '0.1.0', {
    requires: ['base', 'io-xdr', 'json', 'substitute', 'bookie-api']

});


