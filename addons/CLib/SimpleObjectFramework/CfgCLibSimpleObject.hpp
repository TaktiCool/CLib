class CfgCLibSimpleObject {
    // this is the Simplest Way of Create a SO with the SOF
    class testSimpleObject_Single {
        alignOnSurface = 1;
        path = "a3\armor_f_beta\apc_tracked_01\APC_Tracked_01_aa_F.p3d";
        offset[] = {1, 1, 1};
        dir = 0; // Direction
        upVector[] = {0, 180, 90}; // Up Vector

    };
    // this is a Way where Multible SO can get Create with SOF
    class testSimpleObject_Multiple {
        alignOnSurface = 1;
        class Item1 {
            path = "a3\armor_f_beta\apc_tracked_01\APC_Tracked_01_aa_F.p3d";
            offset[] = {1, 1, 1};
            dir = 0; // Direction
            upVector[] = {0, 180, 90}; // Up Vector
        };
        class Item2 {
            path = "a3\armor_f_beta\apc_tracked_01\APC_Tracked_01_aa_F.p3d";
            offset[] = {1, 1, 1};
            dir = 0; // Direction
            upVector[] = {0, 180, 90}; // Up Vector
        };
    };
    class testSimpleObject_Multiple_WithHideSelection {
        class Item1 {
            path = "a3\armor_f_beta\apc_tracked_01\APC_Tracked_01_aa_F.p3d";
            offset[] = {1, 1, 1};
            dir = 0; // Direction
            upVector[] = {0, 180, 90}; // Up Vector
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
            dir = 0; // Direction
            upVector[] = {0, 180, 90}; // Up Vector
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
