class CfgCLibSimpleObject {

    class FOBTest {
        alignOnSurface = 1;
        class item0 {
            path = "a3\supplies_f_heli\cargonets\cargonet_01_ammo_f.p3d";
            offset[] = {-0.262329, 0.00878906, 0.825303};
            dirVector[] = {0, 1, 0};
            upVector[] = {0, 0, 1}; 
        };
        class item1 {
            path = "a3\props_f_exp\military\camps\satelliteantenna_01_f.p3d";
            offset[] = {0.917114, 0.130127, 0.925583};
            dirVector[] = {0.460634, -0.88759, 0};
            upVector[] = {0, 0, 1};
        };
        class item2 {
            path = "a3\structures_f_epb\items\military\ammobox_rounds_f.p3d";
            offset[] = {-0.60498, -0.0910645, 1.73391};
            dirVector[] = {0.699512, -0.714593, -0.00638724};
            upVector[] = {-0.00265204, -0.0115337, 0.99993};
        };
        class item3 {
            path = "a3\structures_f_epb\items\military\ammobox_rounds_f.p3d";
            offset[] = {0.0643311, 0.192627, 1.7319};
            dirVector[] = {-0.642771, -0.76601, -0.00853026};
            upVector[] = {-0.00138107, -0.00997651, 0.999949};
        };
        class item4 {
            path = "a3\structures_f\items\electronics\satellitephone_f.p3d";
            offset[] = {-0.114258, -0.241211, 1.81547};
            dirVector[] = {0.269297, 0.962985, 0.0118218};
            upVector[] = {-0.00265204, -0.0115337, 0.99993};
        };

    };

    // this is the Simplest Way of Create a SO with the SOF
    class testSimpleObject_Single {
        alignOnSurface = 1;
        path = "a3\armor_f_beta\apc_tracked_01\APC_Tracked_01_aa_F.p3d";
        offset[] = {1, 1, 1};
        dirVector[] = {0, 1, 0}; // Direction Vector
        upVector[] = {0, 0, 1}; // Up Vector

    };
    // this is a Way where Multible SO can get Create with SOF
    class testSimpleObject_Multiple {
        alignOnSurface = 1;
        class Item1 {
            path = "a3\armor_f_beta\apc_tracked_01\APC_Tracked_01_aa_F.p3d";
            offset[] = {1, 1, 1};
            dirVector[] = {0, 1, 0}; // Direction Vector
            upVector[] = {0, 0, 1}; // Up Vector
        };
        class Item2 {
            path = "a3\armor_f_beta\apc_tracked_01\APC_Tracked_01_aa_F.p3d";
            offset[] = {1, 1, 1};
            dirVector[] = {0, 1, 0}; // Direction Vector
            upVector[] = {0, 0, 1}; // Up Vector
        };
    };
    class testSimpleObject_Multiple_WithHideSelection {
        class Item1 {
            path = "a3\armor_f_beta\apc_tracked_01\APC_Tracked_01_aa_F.p3d";
            offset[] = {1, 1, 1};
            dirVector[] = {0, 1, 0}; // Direction Vector
            upVector[] = {0, 0, 1}; // Up Vector
            class hideSelection {
                test123Selection = 1;
                test1234Selection = 0;
            };
        };
    };
    class testSimpleObject_Multiple_WithAnimation {
        class Item1 {
            path = "a3\armor_f_beta\apc_tracked_01\APC_Tracked_01_aa_F.p3d";
            offset[] = {1, 1, 1};
            dirVector[] = {0, 1, 0}; // Direction Vector
            upVector[] = {0, 0, 1}; // Up Vector
            class animate {
                class animName {
                    phase = 1;
                    speedType = "BOOL"; // BOOL or NUMBER default is NUMBER
                    speed = 1; // if this is Bool this get Maxed to 1
                };
            };
        };
    };
};
