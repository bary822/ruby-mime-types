# frozen_string_literal: true

require 'set'
require 'forwardable'

# MIME::Types requires a serializable keyed container that returns an empty Set
# on a key miss. Hash#default_value cannot be used because, while it traverses
# the Marshal format correctly, it won't survive any other serialization
# format (plus, a default of a mutable object resuls in a shared mess).
# Hash#default_proc cannot be used without a wrapper because it prevents
# Marshal serialization (and doesn't survive the round-trip).
class MIME::Types::Container #:nodoc:
  extend Forwardable

  def initialize(hash = {})
    @container = {}
    merge!(hash)
  end

  def [](key)
    container[key] || EMPTY_SET
  end

  def []=(key, value)
    case value
    when Set
      container[key] = value
    else
      container[key] = Set[*value]
    end
  end

  def merge(other)
    self.class.new(other)
  end

  def merge!(other)
    tap {
      other = other.kind_of?(MIME::Types::Container) ? other.container : other
      self.container.merge!(other)
      normalize
    }
  end

  def to_hash
    container
  end

  def_delegators :@container,
    :==,
    :count,
    :each,
    :each_value,
    :empty?,
    :flat_map,
    :keys,
    :select,
    :values

  def add(key, value)
    (container[key] ||= Set.new).add(value)
  end

  def marshal_dump
    {}.merge(container)
  end

  def marshal_load(hash)
    @container = hash
  end

  def encode_with(coder)
    debugger
    container.each { |k, v| coder[k] = v.to_a }
  end

  def init_with(coder)
    @container = {}
    coder.map.each { |k, v| container[k] = Set[*v] }
  end

  protected

  attr_accessor :container

  def normalize
    container.each do |k, v|
      next if v.kind_of?(Set)
      container[k] = Set[*v]
    end
  end

  EMPTY_SET = Set.new.freeze
  private_constant :EMPTY_SET
end
