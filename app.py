import streamlit as st
import pandas as pd

st.set_page_config(page_title="Placement Predictor", page_icon="🎓", layout="centered")

@st.cache_data
def load_data():
    return pd.read_csv("placement_data.csv")

df = load_data()

st.title("🎓 Placement Selection Predictor")
st.markdown("Enter your profile to estimate your placement selection chance based on real funnel data.")
st.divider()

cgpa = st.slider("Your CGPA", min_value=6.0, max_value=9.8, value=7.5, step=0.1)

col1, col2 = st.columns(2)
with col1:
    sql_skill = st.radio("Do you have SQL skill?", ["Yes", "No"])
with col2:
    python_skill = st.radio("Do you have Python skill?", ["Yes", "No"])

st.divider()

if st.button("Predict My Chance 🔍", use_container_width=True, type="primary"):

    if cgpa < 7.0:
        band = (6.0, 7.0); band_label = "6 - 7"
    elif cgpa < 8.0:
        band = (7.0, 8.0); band_label = "7 - 8"
    elif cgpa < 9.0:
        band = (8.0, 9.0); band_label = "8 - 9"
    else:
        band = (9.0, 9.9); band_label = "9+"

    filtered = df[
        (df["cgpa"] >= band[0]) & (df["cgpa"] < band[1]) &
        (df["has_sql_skill"] == sql_skill) &
        (df["has_python_skill"] == python_skill)
    ]
    if len(filtered) == 0:
        filtered = df[(df["cgpa"] >= band[0]) & (df["cgpa"] < band[1])]

    total   = len(filtered)
    offers  = len(filtered[filtered["final_offer"] == "Yes"])
    sel_pct = round((offers / total) * 100, 1) if total > 0 else 0
    overall_pct = round((len(df[df["final_offer"] == "Yes"]) / len(df)) * 100, 1)

    sql_yes_pct = round(len(df[(df["has_sql_skill"]=="Yes") & (df["final_offer"]=="Yes")]) / len(df[df["has_sql_skill"]=="Yes"]) * 100, 1)
    sql_no_pct  = round(len(df[(df["has_sql_skill"]=="No")  & (df["final_offer"]=="Yes")]) / len(df[df["has_sql_skill"]=="No"])  * 100, 1)
    sql_impact  = round(sql_yes_pct - sql_no_pct, 1)

    py_yes_pct = round(len(df[(df["has_python_skill"]=="Yes") & (df["final_offer"]=="Yes")]) / len(df[df["has_python_skill"]=="Yes"]) * 100, 1)
    py_no_pct  = round(len(df[(df["has_python_skill"]=="No")  & (df["final_offer"]=="Yes")]) / len(df[df["has_python_skill"]=="No"])  * 100, 1)
    py_impact  = round(py_yes_pct - py_no_pct, 1)

    cgpa_group = df[(df["cgpa"] >= band[0]) & (df["cgpa"] < band[1])]
    cgpa_pct   = round(len(cgpa_group[cgpa_group["final_offer"]=="Yes"]) / len(cgpa_group) * 100, 1)

    # ── Result ──────────────────────────────────────────
    st.subheader("📊 Your Estimated Selection Chance")
    col1, col2, col3 = st.columns(3)
    with col1:
        st.metric("Your Profile", f"{sel_pct}%")
    with col2:
        delta = round(sel_pct - overall_pct, 1)
        st.metric("Dataset Average", f"{overall_pct}%", delta=f"{delta}%")
    with col3:
        st.metric("Students like you", f"{total}")

    st.divider()

    # ── Key Insight ──────────────────────────────────────
    st.subheader("💡 Key Insight")
    if sel_pct >= 25:
        st.success(f"Your profile is **above average** (avg: {overall_pct}%). Strong position — CGPA band {band_label} with your skills is working in your favour.")
    elif sel_pct >= 18:
        if sql_skill == "No":
            st.info(f"Your profile is **around average** ({overall_pct}%). Adding SQL skill could add ~{sql_impact}pp to your chances.")
        else:
            st.info(f"Your profile is **around average** ({overall_pct}%). Improving your CGPA band is the next best lever — it's the strongest predictor in this dataset.")
    else:
        if sql_skill == "No":
            st.warning(f"Your profile is **below average** ({overall_pct}%). Focus on CGPA improvement and acquiring SQL skill (+{sql_impact}pp impact).")
        else:
            st.warning(f"Your profile is **below average** ({overall_pct}%). Focus on improving CGPA — it's the single strongest predictor (nearly 2x difference from lowest to highest band).")

    st.divider()

    # ── Factor Breakdown ─────────────────────────────────
    st.subheader("🔍 Factor Breakdown")
    breakdown_data = {
        "Factor": ["CGPA Band", "SQL Skill", "Python Skill"],
        "Your Value": [band_label, sql_skill, python_skill],
        "Selection % (your value)": [
            f"{cgpa_pct}%",
            f"{sql_yes_pct}%" if sql_skill == "Yes" else f"{sql_no_pct}%",
            f"{py_yes_pct}%" if python_skill == "Yes" else f"{py_no_pct}%"
        ],
        "Impact vs opposite": [
            "Baseline factor",
            f"+{sql_impact}% advantage" if sql_skill == "Yes" else f"-{abs(sql_impact)}% disadvantage",
            f"+{py_impact}% advantage" if python_skill == "Yes" else f"-{abs(py_impact)}% disadvantage"
        ]
    }
    
    st.dataframe(pd.DataFrame(breakdown_data), hide_index=True, use_container_width=True)

    st.divider()

    # ── Charts ───────────────────────────────────────────
    st.subheader("📈 CGPA Band vs Selection Rate")
    cgpa_chart_data = []
    for low, high, label in [(6,7,"6-7"),(7,8,"7-8"),(8,9,"8-9"),(9,9.9,"9+")]:
        g = df[(df["cgpa"] >= low) & (df["cgpa"] < high)]
        pct = round(len(g[g["final_offer"]=="Yes"]) / len(g) * 100, 1) if len(g) > 0 else 0
        cgpa_chart_data.append({"CGPA Band": label, "Selection %": pct})
    st.bar_chart(pd.DataFrame(cgpa_chart_data).set_index("CGPA Band"))

    st.subheader("📈 SQL Skill Impact")
    sql_chart = pd.DataFrame({
        "Group": ["Has SQL", "No SQL"],
        "Selection %": [sql_yes_pct, sql_no_pct]
    })
    st.bar_chart(sql_chart.set_index("Group"))

    st.caption("Based on simulated dataset of 1000 records. Results are indicative, not a guarantee.")