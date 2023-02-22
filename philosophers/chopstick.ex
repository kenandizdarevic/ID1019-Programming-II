defmodule Chopstick do

  def start do
    stick = spawn_link(fn -> available() end)
    {:stick, stick}
  end

  # Recive the lock, remember that you gave away the lock -> statechange to gone()
  def available() do
    receive do
      {:request, ref, from} ->
        :granted
        send(from, {:granted, ref})
        gone(ref)
      :quit ->
        :ok
    end
  end

  # Assumes that the one who sends :return is a philosopher, can be tricked
  def gone(ref) do
    receive do
      {:return, ^ref} ->
        available()
      :quit ->
        :ok
    end
  end

  # If request is sent before release the request will wait in the queue
  def request({:stick, stick}, timeout) when is_number(timeout) do
    send(stick, {:request, self()})
    receive do
      :granted ->
        :ok
    after timeout ->
      :no
    end
  end

  def async({:stick, stick}, ref) do
    send(stick, {:request, ref, self()})
  end

  def sync(ref, timeout) when is_number(timeout) do
    receive do
      {:granted, ^ref} ->
        :ok
      {:granted, _ref} ->
        sync(ref, timeout)
    after timeout ->
      :no
    end
  end

  def return({:stick, stick}, ref) do
    send(stick, {:return, ref})
  end

  def terminate({:stick, stick}) do
    send(stick, :quit)
  end

end
