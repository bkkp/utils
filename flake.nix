{
  outputs = { self }:
  let
    inherit (builtins) mapAttrs;
  in {

    lib = rec {
      midgardOverlay = overlay: (final: prev: { midgard = (prev.midgard or { }) // (overlay final prev); });
      mapMidgardOverlay = mapAttrs (_: overlay: midgardOverlay overlay);
    };

  };
}