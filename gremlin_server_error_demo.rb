#!/usr/bin/env ruby
# frozen_string_literal: true

require 'grumlin'
require 'parallel'

class DemoRepository
  include Grumlin::Sugar

  NODES = 10
  ATTEMPTS = 10

  def run
    nodes = Array.new(NODES) do
      rand(100)
    end

    edges = nodes.map do |node|
      [node, nodes.sample]
    end

    loop do
      parallel_each(Array.new(ATTEMPTS)) do
        nodes.reduce(g) do |t, node_id|
          t.V(node_id)
           .fold
           .coalesce(
             __.unfold,
             __.addV('test_vertex').property(T.id, node_id)
           )
        end.iterate

        edges.reduce(g) do |t, (from, to)|
          t.addE('test_edge').from(__.V(from)).to(__.V(to))
        end.iterate
      rescue Grumlin::VertexAlreadyExistsError
        retry
      end
      g.V.drop.iterate
    end
  end

  private

  def parallel_each(collection)
    Thread.new do # A workaround for forking inside an event loop https://github.com/socketry/async/discussions/165
      ::Parallel.map(collection) do |item|
        Sync do
          yield item
        ensure
          Grumlin.close
        end
      end
    end.join
    collection
  end
end

Grumlin.configure do |config|
  config.url = 'ws://gremlin_server:8182/gremlin'
end

Sync do
  DemoRepository.new.run
ensure
  Grumlin.close
end
