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

  def bench do
    sample = read("./kallocain.txt")
    tree0 = :os.system_time(:millisecond)
    tree = tree(sample)
    tree1 = :os.system_time(:millisecond)

    table0 = :os.system_time(:millisecond)
    table = encode_table(tree)
    table1 = :os.system_time(:millisecond)

    t0 = :os.system_time(:millisecond)
    encode = encode(sample, table)
    t1 = :os.system_time(:millisecond)

    t2 = :os.system_time(:millisecond)
    decode = decode(encode, table)
    t3 = :os.system_time(:millisecond)

    IO.puts("Tree time: #{tree1 - tree0} ms")
    IO.puts("Decode time: #{table1 - table0} ms")
    IO.puts("Encode time: #{t1 - t0} ms")
    IO.puts("Decode time: #{t3 - t2} ms")
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
    binary_encode(tree, [])
  end

  def decode_table(tree) do
    binary_encode(tree, [])
  end

  # Traverse the tree
  def binary_encode({left, right}, path) do
    left_code = binary_encode(left, [0 | path])
    right_code = binary_encode(right, [1 | path])
    left_code ++ right_code
  end
  def binary_encode(char, path) do
    [{char, Enum.reverse(path)}]
  end

  def encode([], _) do [] end
  def encode([char | tail], table) do
    {_, code} = List.keyfind(table, char, 0)
    code ++ encode(tail, table)
  end

  def decode([], _) do [] end
  def decode(seq, table) do
    {char, rest} = decode_char(seq, 1, table)
    [char | decode(rest, table)]
  end

  def decode_char(seq, n, table) do
    {code, rest} = Enum.split(seq, n)
    case List.keyfind(table, code, 1) do
      {char, _} ->
        {char, rest}
      nil ->
        decode_char(seq, n + 1, table)
    end
  end

  def read(file) do
    {:ok, file} = File.open(file, [:read, :utf8])
    binary = IO.read(file, :all)
    File.close(file)

    case :unicode.characters_to_list(binary, :utf8) do
      {:incomplete, list, _} ->
        list
      list ->
        list
    end
  end

end
