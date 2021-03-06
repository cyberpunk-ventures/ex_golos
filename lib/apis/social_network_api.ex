defmodule Golos.SocialNetworkApi do
  @moduledoc """
  Contains all functions to call Golos database_api methods
  """

  def call(method, params) do
    Golos.call(["social_network", method, params])
  end

  # CONTENT

  @doc """
  Returns content data, accepts author and permlink.

  Example response:
  ```
    %{"max_accepted_payout" => "1000000.000 GBG",
    "title" => "[объявление] Краудсейл и Шэрдроп. Дистрибьюция",
    "category" => "ru--kraudseijl", "promoted" => "0.000 GBG",
    "last_update" => "2016-12-06T15:36:54", "created" => "2016-12-05T16:43:03",
    "parent_permlink" => "ru--kraudseijl", "total_vote_weight" => 0,
    "json_metadata" => "{"tags":["ru--kraudseijl","ru--shyerdrop","ru--golos"],"users":["golos","crowdsale","cyberdrop","misha","ether","bender","hipster","litvintech","vitaly-lvov"],"image":["https://dl.dropboxusercontent.com/u/52209381/golos/golos.png","https://dl.dropboxusercontent.com/u/52209381/golos/Screenshot%202016-12-05%2018.30.00.png","https://dl.dropboxusercontent.com/u/52209381/golos/ico_final-min.jpg","https://dl.dropboxusercontent.com/u/52209381/golos/Screenshot%202016-12-06%2002.25.05.png","https://dl.dropboxusercontent.com/u/52209381/golos/card.png"],"links":["https://docs.google.com/spreadsheets/d/1JwCAeRwsu4NzCG20UDM_CnEEsskl0wtvQ7VYjqi233A/edit?usp=sharing","https://golos.io/@litvintech"]}",
    "last_payout" => "2017-01-15T11:00:06",
    "total_payout_value" => "2412.784 GBG", "allow_replies" => true,
    "children_rshares2" => "0", "id" => "2.8.30160",
    "pending_payout_value" => "0.000 GBG", "children" => 15, "replies" => [],
    "body" => "...",
    "active" => "2016-12-06T22:23:06", "net_rshares" => 0,
    "author_rewards" => 10011558, "total_pending_payout_value" => "0.000 GBG",
    "root_comment" => "2.8.30160", "max_cashout_time" => "1969-12-31T23:59:59",
    "root_title" => "[объявление] Краудсейл и Шэрдроп. Дистрибьюция",
    "allow_votes" => true, "percent_steem_dollars" => 10000,
    "children_abs_rshares" => 0, "net_votes" => 90, "author" => "litvintech",
    "curator_payout_value" => "112.100 GBG",
    "permlink" => "obyavlenie-kraudseil-i-sherdrop-distribyuciya",
    "url" => "/ru--kraudseijl/@litvintech/obyavlenie-kraudseil-i-sherdrop-distribyuciya",
    "cashout_time" => "2017-02-14T11:00:06", "parent_author" => "",
    "allow_curation_rewards" => true, "vote_rshares" => 0,
    "reward_weight" => 10000,
    "active_votes" => [%{"percent" => 1000, "reputation" => "15928643268388",
       "rshares" => "1974529666496", "time" => "2016-12-05T17:02:39",
       "voter" => "val", "weight" => "99631990926249375"}, %{...}, ...], "depth" => 0,
    "mode" => "second_payout", "abs_rshares" => 0,
    "author_reputation" => "22784203010137"}
  ```
  """
  @spec get_content(String.t(), String.t()) :: {:ok, map} | {:error, any}
  def get_content(author, permlink) do
    with {:ok, comment} <- call("get_content", [author, permlink]) do
      cleaned =
        comment
        |> Golos.Cleaner.strip_token_names_and_parse(:float)
        |> Golos.Cleaner.parse_json_strings(:json_metadata)
        |> Golos.Cleaner.extract_fields()
        |> Golos.Cleaner.prepare_tags()
        |> Golos.Cleaner.parse_timedate_strings()
        |> Golos.Cleaner.parse_empty_strings()

      {:ok, cleaned}
    else
      err -> err
    end
  end

  @doc """
  Returns a list of replies to the given content, accepts author and permlink.

  Example response:
  ```
  [%{"max_accepted_payout" => "1000000.000 GBG", "title" => "",
  "category" => "ru--kraudseijl", "promoted" => "0.000 GBG",
  "last_update" => "2016-12-05T16:50:09",
  "created" => "2016-12-05T16:50:09",
  "parent_permlink" => "obyavlenie-kraudseil-i-sherdrop-distribyuciya",
  "total_vote_weight" => 0,
  "json_metadata" => "{\"tags\":[\"ru--kraudseijl\"]}",
  "last_payout" => "2017-01-15T11:00:06",
  "total_payout_value" => "12.892 GBG", "allow_replies" => true,
  "children_rshares2" => "0", "id" => "2.8.30165",
  "pending_payout_value" => "0.000 GBG", "children" => 1,
  "replies" => [],
  "body" => "И он сказал поехали...",
  "active" => "2016-12-06T01:57:24", "net_rshares" => 0,
  "author_rewards" => 53499,
  "total_pending_payout_value" => "0.000 GBG",
  "root_comment" => "2.8.30160",
  "max_cashout_time" => "1969-12-31T23:59:59",
  "root_title" => "[объявление] Краудсейл и Шэрдроп. Дистрибьюция",
  "allow_votes" => true, "percent_steem_dollars" => 10000,
  "children_abs_rshares" => 0, "net_votes" => 6,
  "author" => "dmilash", "curator_payout_value" => "4.296 GBG",
  "permlink" => "re-litvintech-obyavlenie-kraudseil-i-sherdrop-distribyuciya-20161205t165002890z",
  "url" => "/ru--kraudseijl/@litvintech/obyavlenie-kraudseil-i-sherdrop-distribyuciya#@dmilash/re-litvintech-obyavlenie-kraudseil-i-sherdrop-distribyuciya-20161205t165002890z",
  "cashout_time" => "1969-12-31T23:59:59",
  "parent_author" => "litvintech",
  "allow_curation_rewards" => true, "vote_rshares" => 0,
  "reward_weight" => 10000, "active_votes" => [], "depth" => 1,
  "mode" => "second_payout", "abs_rshares" => 0,
  "author_reputation" => "37110534901202"},
  %{...},
  ...]
  ```
  """
  @spec get_content_replies(String.t(), String.t()) :: {:ok, map} | {:error, any}
  def get_content_replies(author, permlink) do
    call("get_content_replies", [author, permlink])
  end


  @doc """
  Get state for the provided path.
  Example result:
  ```
  %{
    "accounts" => ...,
    "categories" => ...,
    "category_idx" => ...,
    "content" => ...,
    "current_route" => ...,
    "discussion_idx" => ...,
    "error" => ...,
    "feed_price" => ...,
    "pow_queue" => ...,
    "props" => ...,
    "witness_schedule" => ...,
    "witnesses" => ... }
  ```
  """
  @spec get_state(String.t()) :: {:ok, map} | {:error, any}
  def get_state(path) do
    call("get_state", [path])
  end

  @doc """
  Get categories. Accepts wanted metric, after_category, limit.
  Example result:
  ```
  %{
    "accounts" => ...,
    "categories" => ...,
    "category_idx" => ...,
    "discussion_idx" => ...,
    "error" => ...,
    "feed_price" => ...,
    "pow_queue" => ...,
    "props" => ...,
    "witness_schedule" => ...,
    "current_virtual_time" => ...,
    "id" => ...,
    "majority_version" => ...,
    "median_props" => ...,
    "next_shuffle_block_num" => ...,
    "witnesses" => ... }
  ```
  """
  @spec get_categories(atom, String.t(), integer) :: {:ok, [map]} | {:error, any}
  def get_categories(metric, after_category, limit) do
    method = "get_" <> Atom.to_string(metric) <> "_categories"
    call(method, [after_category, limit])
  end

  @doc """
  Gets current GBG to GOLOS conversion requests for given account.
  Example result:
  ```
  [%{"amount" => "100.000 GBG", "conversion_date" => "2017-02-17T18:59:42",
     "id" => "2.15.696", "owner" => "ontofractal", "requestid" => 1486753166}]
  ```
  """
  @spec get_conversion_requests() :: {:ok, [map]} | {:error, any}
  def get_conversion_requests() do
    call("get_conversion_requests", ["ontofractal"])
  end

  @doc """
  Returns past owner authorities that are valid for account recovery.
  Doesn't seem to work at this moment.
  ```
  ```
  """
  @spec get_owner_history(String.t()) :: {:ok, [map]} | {:error, any}
  def get_owner_history(name) do
    call("get_owner_history", [name])
  end

  @doc """
  Get witnesses by ids

  ## Example response
  ```
  [%{"created" => "2016-10-18T11:21:18",
     "hardfork_time_vote" => "2016-10-18T11:00:00",
     "hardfork_version_vote" => "0.0.0", "id" => "2.3.101",
     "last_aslot" => 3323895, "last_confirmed_block_num" => 3318746,
     "last_sbd_exchange_update" => "2017-02-09T06:10:33",
     "last_work" => "0000000000000000000000000000000000000000000000000000000000000000",
     "owner" => "hipster", "pow_worker" => 0,
     "props" => %{"account_creation_fee" => "1.000 GOLOS",
       "maximum_block_size" => 65536, "sbd_interest_rate" => 1000},
     "running_version" => "0.14.2",
     "sbd_exchange_rate" => %{"base" => "1.742 GBG",
       "quote" => "1.000 GOLOS"},
     "signing_key" => "GLS6oRsauXhqxhpXbK3dJzFBGEWVoX6BjVT5z8BwNzgV38DzFat9E",
     "total_missed" => 10,
     "url" => "https://golos.io/ru--delegaty/@hipster/delegat-hipster",
     "virtual_last_update" => "2363092957490310521961963807",
     "virtual_position" => "186709431624610119071729411416709427966",
     "virtual_scheduled_time" => "2363094451567901047152350987",
     "votes" => "102787791122912956"},
  %{...} ]
  ```
  """
  @spec get_witnesses([String.t]) :: {:ok, [map]} | {:error, any}
  def get_witnesses(ids) do
   call("get_witnesses", [ids])
  end

  @doc """
  Get witnesses by votes. Example response is the same as get_witnesses.
  """
  @spec get_witnesses_by_vote(integer, integer) :: {:ok, [map]} | {:error, any}
  def get_witnesses_by_vote(from, limit) do
    call("get_witnesses_by_vote", [from, limit])
  end

  @doc """
  Lookup witness accounts

  Example response:
  ```
  ["creator", "creatorgalaxy", "crypto", "cryptocat", "cyberfounder", "cybertech-01", "d00m", "dacom", "dance", "danet"]
  ```
  """
  @spec lookup_witness_accounts(String.t(), integer) :: {:ok, [String.t()]} | {:error, any}
  def lookup_witness_accounts(lower_bound_name, limit) do
    call("lookup_witness_accounts", [lower_bound_name, limit])
  end

  @doc """
  Get witness count

  Example response: `997`
  """
  @spec get_witness_count() :: {:ok, [String.t()]} | {:error, any}
  def get_witness_count() do
    call("get_witness_count", [])
  end

  @doc """
  Get active witnesses

  Example response:
  ```
  ["primus", "litvintech", "yaski", "serejandmyself", "dark.sun", "phenom",
   "hipster", "gtx-1080-sc-0048", "lehard", "aleksandraz", "dr2073", "smailer",
   "on0tole", "roelandp", "arcange", "testz", "vitaly-lvov", "xtar", "anyx",
   "kuna", "creator"]
  ```
  """
  @spec get_active_witnesses() :: {:ok, [String.t()]} | {:error, any}
  def get_active_witnesses() do
    call("get_active_witnesses", [])
  end

  @doc """
  Get miner queue

  Example response:
  ```
  ["gtx-1080-sc-0083", "gtx-1080-sc-0016", "gtx-1080-sc-0084", "gtx-1080-sc-0017",
   "gtx-1080-sc-0085", "gtx-1080-sc-0018", "penguin-11", "gtx-1080-sc-0028",
   "gtx-1080-sc-0023", "gtx-1080-sc-0080", ...]
  ```
  """
  @spec get_miner_queue() :: {:ok, [String.t()]} | {:error, any}
  def get_miner_queue() do
    call("get_miner_queue", [])
  end

  @doc """
  Get *all* account votes

  Example response:
  ```
  [%{"authorperm" => "rusldv/programmiruem-na-php-vvedenie", "percent" => 10000,
     "rshares" => 130036223, "time" => "2017-01-26T20:06:03", "weight" => 0},
     %{...}, ...] ```
  """
  @spec get_account_votes(String.t()) :: {:ok, [map]} | {:error, any}
  def get_account_votes(name) do
    call("get_account_votes", [name])
  end

  @doc """
  Get active votes on the given content. Accepts author and permlink.

  Example response:
  ```
  [%{"percent" => 6900, "reputation" => "28759071217014",
               "rshares" => "18897453242648", "time" => "2017-01-27T09:20:21",
               "voter" => "hipster", "weight" => "51460692508758354"},
     %{...}, ...] ```
  """
  @spec get_active_votes(String.t(), String.t()) :: {:ok, [map]} | {:error, any}
  def get_active_votes(account, permlink) do
    call("get_active_votes", [account, permlink])
  end
end
