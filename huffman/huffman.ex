defmodule Huffman do

  def sample do
    'the quick brown fox jumps over the lazy dog
    this is a sample text that we will use when we build
    up a table we will only handle lower case letters and
    no punctuation symbols the frequency will of course not
    represent english but it is probably not that far off'
  end

  def text() do
    'this is something that we should encode'
  end

  def test do
    sample = sample()
    tree = tree(sample)
    encode = encode_table(tree)
    decode = decode_table(tree)
    text = text()
    seq = encode(text, encode)
    decode(seq, decode)
  end

  # Create Huffman-tree from sample
  def tree(sample) do
    freq = freq(sample)
    huffman(freq)
  end

  def freq(sample) do freq(sample, []) end
  def freq([], freq) do freq end
  def freq([char | tail], freq) do
    freq(tail, add(char, freq))
  end

  def add(char, []) do [{char, 1}] end
  def add(char, [{char, n} | tail]) do
    [{char, n + 1} | tail]
  end
  def add(char, [head | tail]) do
    [head | add(char, tail)]
  end

  def huffman(freq) do
    sorted = Enum.sort(freq, fn({_, f1}, {_, f2}) -> f1 < f2 end)
    huffman_tree(sorted)
  end

  def huffman_tree([{tree, _}]) do tree end
  def huffman_tree([{left, lfreq}, {right, rfreq} | tail]) do
    parent_node = {{left, right}, lfreq + rfreq}
    huffman_tree(insert(parent_node, tail))
  end

  def insert({node, freq}, []) do [{node, freq}] end
  def insert({node, freq}, [{current_node, current_freq} | tail]) when freq <  current_freq do
    [{node, freq}, {current_node, current_freq} | tail]
  end
  def insert({node, freq}, [{current_node, current_freq} | tail]) do
    [{current_node, current_freq} | insert({node, freq}, tail)]
  end

  def encode_table(tree) do
    # FIX
  end

  def decode_table(tree) do
    # FIX
  end

  def encode(text, table) do
    # FIX
  end

  def decode(seq. tree) do
    # FIX
  end

  # Tree has chars as leafs, low freq -> long branch, high -> short
  # Leaf represented as single char and a node as {left, right}
  # New node, {{c1, c2}, f1 + f2}
end
