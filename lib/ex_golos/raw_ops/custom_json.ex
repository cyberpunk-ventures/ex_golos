defmodule Golos.RawOps.CustomJson do
  @enforce_keys [:id, :json, :required_auths, :required_posting_auths]
  defstruct [:id, :json, :required_auths, :required_posting_auths]
end
