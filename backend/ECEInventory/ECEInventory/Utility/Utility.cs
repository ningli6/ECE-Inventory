using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ECEInventory {
    public class Utility {
     
        public static Boolean IsSameString(string s1, string s2) {
            for (int i = 0; i < s1.Length && i < s2.Length; i++) {
                if (s1[i] != s2[i]) return false;
            }
            return true;
        }
        public static int GetEditDistance(string s1, string s2) {
            if (s1.Length == 0) return s2.Length;
            if (s2.Length == 0) return s1.Length;
            if (s1[0] == s2[0]) {
                return GetEditDistance(s1.Substring(1), s2.Substring(1));
            } else {
                int tmp = int.MaxValue;
                tmp = Math.Min(tmp, GetEditDistance(s1.Substring(1), s2.Substring(0)) + 1);
                tmp = Math.Min(tmp, GetEditDistance(s1.Substring(0), s2.Substring(1)) + 1);
                return tmp;
            }
        }
    }
}