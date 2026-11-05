#include <iostream>
#include <queue>
#include <map>
using namespace std;

struct Node
{
    char ch;
    int freq;
    Node *left, *right;

    Node(char c, int f)
    {
        ch = c;
        freq = f;
        left = right = NULL;
    }
};

// Min Priority Queue Comparator
struct Compare
{
    bool operator()(Node* a, Node* b)
    {
        return a->freq > b->freq;
    }
};

// Generate Huffman Codes
void generateCodes(Node* root, string code, map<char, string>& codes)
{
    if (root == NULL)
        return;

    if (root->left == NULL && root->right == NULL)
    {
        codes[root->ch] = (code == "") ? "0" : code;
        return;
    }

    generateCodes(root->left, code + "0", codes);
    generateCodes(root->right, code + "1", codes);
}

int main()
{
    string text;
    map<char, int> freq;
    map<char, string> codes;

    cout << "Enter text: ";
    getline(cin, text);

    // Calculate frequency
    for (char ch : text)
        freq[ch]++;

    // Create Min Priority Queue
    priority_queue<Node*, vector<Node*>, Compare> pq;

    for (auto p : freq)
        pq.push(new Node(p.first, p.second));

    // Build Huffman Tree
    while (pq.size() > 1)
    {
        Node* left = pq.top();
        pq.pop();

        Node* right = pq.top();
        pq.pop();

        Node* parent = new Node('\0', left->freq + right->freq);

        parent->left = left;
        parent->right = right;

        pq.push(parent);
    }

    Node* root = pq.top();

    // Generate codes
    generateCodes(root, "", codes);

    cout << "\nHuffman Codes:\n";

    for (auto p : codes)
        cout << p.first << " : " << p.second << endl;

    // Encode text
    string encoded = "";

    for (char ch : text)
        encoded += codes[ch];

    cout << "\nEncoded Text: " << encoded;

    return 0;
}
