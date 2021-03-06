defmodule Golos.TagApi do
  alias Golos.Cleaner

  @moduledoc """
  Contains all functions to call Golos database_api methods
  """

  def call(method, params) do
    with {:ok, contents} <- Golos.call(["tags", method, params]) do
      cleaned_contents =
        cond do
          method =~ "get_discussions" ->
            for content <- contents do
              content
              |> Cleaner.parse_timedate_strings()
              |> Cleaner.strip_token_names_and_parse()
              |> Cleaner.parse_votes()
            end

          true ->
            contents
        end

      {:ok, cleaned_contents}
    else
      e -> e
    end
  end

  @doc """
  If start_permlink is empty then only before_date will be considered. If both are specified the earlier of the two metrics will be used.
  before_date format is: `2017-02-07T14:34:11`.


  Example response:
  ```
  ContentResult has the same shape as a result returned by get_content.
  Example result:
  ```
  [ContentResult, ContentResult, ...]
  ```
  """
  @spec get_discussions_by_author_before_date(String.t(), String.t(), NaiveDateTime.t(), integer) ::
          {:ok, map} | {:error, any}
  def get_discussions_by_author_before_date(
        author,
        start_permlink,
        %NaiveDateTime{} = before_date,
        limit
      ) do
    timestamp_str = NaiveDateTime.to_iso8601(before_date)

    params = [
      author,
      start_permlink,
      timestamp_str,
      limit
    ]

    call("get_discussions_by_author_before_date", params)
  end

  # UNKNOWN parse error
  # @doc"""
  # If start_permlink is empty then only before_date will be considered. If both are specified the earlier of the two metrics will be used.
  # before_date format is: `2017-02-07T14:34:11`
  # Example response:
  # ```
  # ContentResult has the same shape as a result returned by get_content.
  # Example result:
  # ```
  # [ContentResult, ContentResult, ...]
  # ```
  # """
  # @spec get_replies_by_last_update(String.t, String.t, String.t, integer) :: {:ok, map} | {:error, any}
  # def get_replies_by_last_update(author, start_permlink, before_date, limit) do
  #   call("get_replies_by_last_update", [author, start_permlink, before_date, limit])
  # end

  @doc """
  Get trending tags

  Example result:
  ```
  [
    %{"comments" => 386, "id" => "5.4.29", "net_votes" => 16361,
    "tag" => "golos", "top_posts" => 448,
    "total_children_rshares2" => "263770002351940021381162037540",
    "total_payout" => "1210679.260 GBG"},
    %{"comments" => 0, "id" => "5.4.6338", "net_votes" => 59,
    "tag" => "golos-io", "top_posts" => 1,
    "total_children_rshares2" => "7597368466598778563409",
    "total_payout" => "1533.724 GBG"},
    %{"comments" => 1, "id" => "5.4.741", "net_votes" => 39,
    "tag" => "golos-soft", "top_posts" => 2,
    "total_children_rshares2" => "87745768291122276983586401",
    "total_payout" => "12.812 GBG"},
  ...]
  ```
  """
  @spec get_trending_tags(String.t(), integer) :: {:ok, [map]} | {:error, any}
  def get_trending_tags(after_tag, limit) do
    call("get_trending_tags", [after_tag, limit])
  end

  @doc """
  Get discussions by the wanted metric. Accepts a metric atom and a map with a following query params: %{tag: `String.t`, limit: `integer`}
  ContentResult has the same shape as a result returned by get_content.
  Example result:
  ```
  [ContentResult, ContentResult, ...]
  ```
  """
  @spec get_discussions_by(atom, map) :: {:ok, [map]} | {:error, any}
  def get_discussions_by(metric, query) do
    method = "get_discussions_by_" <> Atom.to_string(metric)
    call(method, [query])
  end
end
