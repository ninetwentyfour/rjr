# RJR MultiNode Endpoint
#
# Implements the RJR::Node interface to satisty JSON-RPC requests over multiple protocols
#
# Copyright (C) 2012 Mohammed Morsi <mo@morsi.org>
# Licensed under the Apache License, Version 2.0

require 'eventmachine'
require 'rjr/node'
require 'rjr/message'

module RJR

# Multiple node definition, allows a developer to easily multiplex transport
# mechanisms to serve JSON-RPC requests over.
#
# @example Listening for json-rpc requests over amqp, tcp, http, and websockets
#   # register rjr dispatchers (see RJR::Dispatcher)
#   RJR::Dispatcher.add_handler('hello') { |name|
#     # optionally use @rjr_node_type to handle different transport types
#     "Hello #{name}!"
#   }
#
#   amqp_server = RJR::TCPNode.new :node_id => 'amqp_server', :broker => 'localhost'
#   tcp_server  = RJR::TCPNode.new :node_id => 'tcp_server',  :host => 'localhost', :port => '7777'
#   web_server  = RJR::WebNode.new :node_id => 'tcp_server',  :host => 'localhost', :port => '80'
#   ws_server   = RJR::WebNode.new :node_id => 'tcp_server',  :host => 'localhost', :port => '8080'
#
#   server = RJR::MultiNode.new :node_id => 'server',
#                               :nodes   => [amqp_server, tcp_server, web_server, ws_server]
#   server.listen
#   server.join
#
#   # invoke requests as you normally would via any protocol
#
class MultiNode < RJR::Node
  # MultiNode initializer
  # @param [Hash] args the options to create the tcp node with
  # @option args [Array<RJR::Node>] :nodes array of nodes to use to listen to new requests on
  def initialize(args = {})
    super(args)
    @nodes = args[:nodes]
  end

  # Add node to multinode
  # @param [RJR::Node] node the node to add
  def <<(node)
    @nodes << node
  end


  # Instruct Node to start listening for and dispatching rpc requests
  #
  # Implementation of {RJR::Node#listen}
  def listen
    @nodes.each { |node|
      node.listen
    }
  end
end

end
