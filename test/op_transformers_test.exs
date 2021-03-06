defmodule Golos.RawOps.MungersTest do
  use ExUnit.Case, async: true
  alias Golos.RawOps
  alias Golos.MungedOps
  doctest Golos

  test "transfer op cleaned correctly " do
    op = %RawOps.Transfer{
      to: "bob",
      from: "alice",
      amount: "100 GBG",
      memo: "nice cypher you've got there"
    }

    prepared = RawOps.Munger.parse(op)

    assert prepared == %MungedOps.Transfer{
             to: "bob",
             from: "alice",
             amount: 100.0,
             token: "GBG",
             memo: "nice cypher you've got there"
           }
  end

  test "comment op cleaned correctly " do
    op = %RawOps.Comment{
      body: "body1",
      title: "",
      author: "alice",
      permlink: "permlink1",
      json_metadata: "{\"tags\":[\"tag1\"],\"app\":\"glasnost/0.1\"}",
      parent_author: "parent_author1",
      parent_permlink: "parent_permlink1"
    }

    prepared = RawOps.Munger.parse(op)
    json_metadata = %{tags: ["tag1"], app: "glasnost/0.1"}

    assert prepared == %MungedOps.Comment{
             body: "body1",
             title: nil,
             author: "alice",
             permlink: "permlink1",
             tags: json_metadata.tags,
             app: json_metadata.app,
             json_metadata: json_metadata,
             parent_author: "parent_author1",
             parent_permlink: "parent_permlink1"
           }
  end

  test "comment with no parent_author op cleaned correctly " do
    op = %RawOps.Comment{
      body: "body1",
      title: "",
      author: "alice",
      permlink: "permlink1",
      json_metadata: "{\"tags\":[\"tag1\"],\"app\":\"steemit/0.1\"}",
      parent_author: "",
      parent_permlink: "category"
    }

    prepared = RawOps.Munger.parse(op)
    json_metadata = %{tags: ["tag1"], app: "steemit/0.1"}

    assert prepared == %MungedOps.Comment{
             body: "body1",
             title: nil,
             author: "alice",
             permlink: "permlink1",
             tags: json_metadata.tags,
             app: json_metadata.app,
             json_metadata: json_metadata,
             parent_author: nil,
             parent_permlink: "category"
           }
  end

  test "follow op cleaned and parsed correctly " do
    op = %RawOps.CustomJson{
      id: "follow",
      json:
        "[\"follow\",{\"follower\":\"follower1\",\"following\":\"following1\",\"what\":[\"blog\"]}]",
      required_auths: [],
      required_posting_auths: ["follower1"]
    }

    prepared = RawOps.Munger.parse(op)

    assert prepared == %MungedOps.Follow{
             follower: "follower1",
             following: "following1",
             what: ["blog"]
           }
  end

  test "reblog op cleaned and parsed correctly " do
    op = %RawOps.CustomJson{
      id: "follow",
      json:
        "[\"reblog\",{\"account\":\"account1\",\"author\":\"author1\",\"permlink\":\"permlink1\"}]",
      required_auths: [],
      required_posting_auths: ["account1"]
    }

    prepared = RawOps.Munger.parse(op)

    assert prepared == %MungedOps.Reblog{
             account: "account1",
             author: "author1",
             permlink: "permlink1"
           }
  end

  test "transfer_to_vesting op cleaned and parsed correctly " do
    op = %RawOps.TransferToVesting{to: "account1", from: "account2", amount: "3.140 GOLOS"}
    prepared = RawOps.Munger.parse(op)

    assert prepared == %MungedOps.TransferToVesting{
             to: "account1",
             from: "account2",
             amount: 3.14,
             token: "GOLOS"
           }
  end

  test "feed_publish op cleaned and parsed correctly " do
    op = %RawOps.FeedPublish{
      publisher: "account1",
      exchange_rate: %{base: "2.295 GBG", quote: "1.000 GOLOS"}
    }

    prepared = RawOps.Munger.parse(op)

    assert prepared == %MungedOps.FeedPublish{
             publisher: "account1",
             base_token: "GBG",
             base_amount: 2.295,
             quote_token: "GOLOS",
             quote_amount: 1.0
           }
  end
end
