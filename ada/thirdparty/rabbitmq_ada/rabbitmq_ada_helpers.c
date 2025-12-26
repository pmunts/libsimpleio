/*
 * RabbitMQ Ada bindings - C helper functions
 * Provides non-variadic wrappers for variadic librabbitmq functions
 */

#include <rabbitmq-c/amqp.h>
#include <rabbitmq-c/tcp_socket.h>

AMQP_EXPORT
amqp_rpc_reply_t AMQP_CALL amqp_login(amqp_connection_state_t state,
                                      char const *vhost, int channel_max,
                                      int frame_max, int heartbeat,
                                      amqp_sasl_method_enum sasl_method, ...) __attribute__ ((weak));

/* Wrapper for amqp_login with PLAIN authentication */
amqp_rpc_reply_t rabbitmq_ada_login_plain(
    amqp_connection_state_t state,
    const char *vhost,
    int channel_max,
    int frame_max,
    int heartbeat,
    const char *username,
    const char *password)
{
    return amqp_login(state, vhost, channel_max, frame_max, heartbeat,
                      AMQP_SASL_METHOD_PLAIN, username, password);
}
